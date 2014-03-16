#!/usr/bin/env python
# -*- coding: utf-8 -*-
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#       This file is part of the E-Cell System
#
#       Copyright (C) 1996-2014 Keio University
#       Copyright (C) 2008-2014 RIKEN
#       Copyright (C) 2005-2009 The Molecular Sciences Institute
#
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#
# E-Cell System is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
# 
# E-Cell System is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public
# License along with E-Cell System -- see the file COPYING.
# If not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
# 
#END_HEADER

__program__   = 'convertCellML2EML'
__version__   = '0.1'
__author__    = 'Yasuhiro Naito <ynaito@e-cell.org>'
__copyright__ = 'Keio University, RIKEN'
__license__   = 'GPL'


from ecell.eml import *
from CellML import *

from copy import deepcopy
import re
import numbers


class ecell3Model( object ):
    
    def __init__( self, CellML ):
        
        self.Entity_type_strings = [ 'System', 'Variable', 'Process', 'Stepper' ]
        
        self.Systems   = []
        self.Variables = []
        self.Processes = []
        
        self._get_Systems( CellML )
        
#        print '\nSystems:\n'
#        for S in self.Systems:
#            print '%s:%s' % ( S.path, S.ID )
#        print '\n'
        
        self._get_Variables( CellML )
        self._get_Processes( CellML )
    
    ##-------------------------------------------------------------------------------------------------
    def _get_Systems( self, CellML ):
        
        self.Systems.append( System( '', '/' ) )
        
        for me, children in CellML.containment_hierarchies.iteritems():
            
            self._get_sub_Systems( self.Systems[ 0 ], me, children )
        
    ##-------------------------------------------------------------------------------------------------
    def _get_sub_Systems( self, parent_System, me, children ):
        
        my_System = System( self._convert_Entity_to_path( parent_System ), me )
        self.Systems.append( my_System )
        
        for child, grandchildren in children.iteritems():
            self._get_sub_Systems( my_System, child, grandchildren )
        
    ##-------------------------------------------------------------------------------------------------
    def _get_Variables( self, CellML ):
        
        for gv in CellML.grobal_variables:
            
            self.Variables.append( Variable( 
                self._get_path_of_super_component( gv.component ),
                gv.name,
                gv.initial_value ) )
            
#            print 'Variable:%s:%s' % ( self.Variables[ -1 ].path, self.Variables[ -1 ].ID )
        
        ## SIZE Variable
        
        for S in self.Systems:
            if len( [ V for V in self.Variables 
                if ( V.ID == 'SIZE' and ( V.path == self._get_path_of_super_component( S.ID ) ) ) ] ) == 0:
                
                self.Variables.append( Variable( 
                    self._get_path_of_super_component( S.ID ),
                    'SIZE',
                    1.0 ) )
        
        
    ##-------------------------------------------------------------------------------------------------
    def _get_Processes( self, CellML ):
        
        for c in CellML.components:
            
            VariableReference_list = [ self._get_VariableReference( lv, c, CellML ) for lv in c.variables ]
#            math = [ m for m in c.maths ]
            path = self._get_path_of_super_component( c.name )
            
#            print '\nSystem: %s' % c_name
#            print 'variables: %s' % variables
            
            [ self._append_Process( m, VariableReference_list, path ) for m in c.maths ]
    
    ##-------------------------------------------------------------------------------------------------
    def _get_VariableReference( self, lv, c, CellML ):
        
        ## lv : local_variable オブジェクト
        ## c  : component オブジェクト
        
        for gv in CellML.grobal_variables:
            
            for va in gv.connection:
                if ( va.component == c.name ) and ( va.name == lv.name ):
                    return ( lv.name, ':{0}:{1}'.format( self._get_path_of_super_component( gv.component ), gv.name ) )
        
        raise TypeError, "_get_VariableReference(): global variable is not found."
    
    ##-------------------------------------------------------------------------------------------------
    def _append_Process( self, math, VariableReference_list, path ):
        
        ## math: MathMLオブジェクト
        ## variables: variable名のリスト
        ## path: path
        
        ID = math.variable
        
        if math.type == CELLML_MATH_ASSIGNMENT_EQUATION:
            cls = 'ExpressionAssignmentProcess'
        elif math.type == CELLML_MATH_RATE_EQUATION:
            cls = 'ExpressionFluxProcess'
        else:
            return
        
        Expression, VariableReferenceList = self._get_Expression_and_VariableReferenceList( math, VariableReference_list )
        
        self.Processes.append( Process( cls, path, ID, VariableReferenceList, Expression ) )
#        print '\n%s:%s:%s' % ( self.Processes[ -1 ].cls, self.Processes[ -1 ].path, self.Processes[ -1 ].ID )
#        print '    %s' % self.Processes[ -1 ].Expression
#        print '    %s\n' % self.Processes[ -1 ].VariableReferenceList
    
    ##-------------------------------------------------------------------------------------------------
    def _get_Expression_and_VariableReferenceList( self, math, VariableReference_list ):
        
        math_Element = deepcopy( math.right_side )
        
        ci_list = [ ci for ci in math_Element.findall( './/' + math.tag[ 'ci' ] ) ]
        ci_text_list = [ ci.text for ci in ci_list ]
        
        if not ( math.variable in ci_text_list ):
            ci_text_list.append( math.variable )
        
        VariableReferenceList = [ list( v ) for v in VariableReference_list if ( v[ 0 ] in ci_text_list ) ]
        
        for vr in VariableReferenceList:
            if math.variable == vr[ 0 ]:
                vr.append( '1' )
            else:
                vr.append( '0' )
        
        for v in VariableReference_list:
            for ci in ci_list:
                if ci.text == v[ 0 ]:
                    ci.text = v[ 0 ] + '.Value'
        
        return ( MathML( math_Element, CELLML_MATH_RIGHT_SIDE ).get_expression_str(),
                 VariableReferenceList )
    
    ##-------------------------------------------------------------------------------------------------
    def _connect_paths( self, paths ):
        
        # paths は文字列またはリスト
        # Entity型あるいは '/', '.', '..' のいずれかが冒頭にある（部分pathには対応しない）
        
        if isinstance( paths, list ):
            pass
        
        if isinstance( paths, tuple ):
            paths = list( deepcopy( paths ) )
            
        elif isinstance( paths, str ):
            paths = paths.split( ':' )
        
        else:
            raise TypeError, "paths must be list or str object."
        
        _paths = []
        for dir in paths:
            if dir != '/':
                _paths.extend( dir.split( '/' ) )
        
        if _paths[ 0 ] in self.Entity_type_strings:
            _paths( 0 )
        
        _paths = [ p for p in _paths if p != '' ]
        
        if _paths == []:
            return '/'
        elif not ( _paths[ 0 ] in ( '.', '..' ) ):
            _paths.insert( 0, '' )
        
        return '/'.join( _paths )
    
    ##-------------------------------------------------------------------------------------------------
    def _convert_Entity_to_path( self, Entity ):
        
        return self._connect_paths( ( Entity.path, Entity.ID ) )
    
    ##-------------------------------------------------------------------------------------------------
    def _get_path_of_super_component( self, super_component_name ):
        
        for S in self.Systems:
           if S.ID == super_component_name:
               return self._convert_Entity_to_path( S )
        return None


class System( object ):
        
    def __init__( self, path, ID, Name = '__none__' ):
        
        self.path  = path
        self.ID    = ID
        self.Name  = Name
        


class Variable( object ):
        
    def __init__( self, path, ID, Value = None, Name = '__none__' ):
        
        self.path  = path
        self.ID    = ID
        if isinstance( Value, numbers.Number ):
            self.Value = Value
        else:
            self.Value = 0.0    #### for DEBUG
#            self.Value = '__UNDEFINED__'
        self.Name  = Name
        


class Process( object ):
        
    def __init__( self, cls, path, ID, VariableReferenceList, Expression = '0.0', Name = '__none__' ):
        
        self.cls        = cls
        self.path       = path
        self.ID         = ID
        self.Expression = Expression
        self.Name       = Name
        self.VariableReferenceList = VariableReferenceList


def get_eml( cellml_file_path ):
    
    model = ecell3Model( CellML( cellml_file_path ) )
    
    eml = Eml()
    
    ## Stepper
    
    eml.createStepper( 'FixedODE1Stepper'   , 'ODE' )
    eml.createStepper( 'DiscreteTimeStepper', 'DT' )
    
    default_Stepper_ID = 'ODE'
    
    for s in model.Systems:
        
        _FullID = 'System:{0}:{1}'.format( s.path, s.ID )
        eml.createEntity( 'System', _FullID )
        eml.setEntityProperty( _FullID, 'Name',  [ s.Name ] )
        eml.setEntityProperty( _FullID, 'StepperID', [ default_Stepper_ID ] )
        
    for v in model.Variables:
        
        _FullID = 'Variable:{0}:{1}'.format( v.path, v.ID )
        eml.createEntity( 'Variable', _FullID )
        if v.Value == '__UNDEFINED__':       ## __UNDEFINED__ がEMLに埋め込まれるとsessionが転ける
            eml.setEntityProperty( _FullID, 'Value', [ str( 0.0 ) ] )
        else:
            eml.setEntityProperty( _FullID, 'Value', [ str( v.Value ) ] )
        eml.setEntityProperty( _FullID, 'Name',  [ v.Name ] )

    for p in model.Processes:
        
        _FullID = 'Process:{0}:{1}'.format( p.path, p.ID )
        eml.createEntity( p.cls, _FullID )
        eml.setEntityProperty( _FullID, 'Name', [ p.Name ] )
        eml.setEntityProperty( _FullID, 'Expression', [ p.Expression ] )
        eml.setEntityProperty( _FullID, 'VariableReferenceList', p.VariableReferenceList )

    return eml


########  MAIN  ########

eml = get_eml( './tentusscher_noble_noble_panfilov_2004_a.cellml' )
eml.save( './tentusscher_noble_noble_panfilov_2004_a.eml' )

eml = get_eml( './hodgkin_huxley_1952.cellml' )
eml.save( './hodgkin_huxley_1952.eml' )

eml = get_eml( './goldbeter_1991.cellml' )
eml.save( './goldbeter_1991.eml' )

