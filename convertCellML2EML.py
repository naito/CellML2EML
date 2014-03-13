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


from CellML import *

from copy import deepcopy
import re


class ecell3Model( object ):
    
    def __init__( self, CellML ):
        
        self.Entity_type_strings = [ 'System', 'Variable', 'Process', 'Stepper' ]
        
        self.Systems   = {}
        self.Variables = []
        self.Processes = []
        
        self._get_Systems( CellML )
        #print '\nSystem:\n%s\n' % self.Systems
        
        self._get_Variables( CellML )
        self._get_Processes( CellML )
    
    ##-------------------------------------------------------------------------------------------------
    def _get_Systems( self, CellML ):
        
        self.Systems [ '/' ] = ''  ## component (ID) : ecell3_path
        
        for me, children in CellML.containment_hierarchies.iteritems():
            
            self._get_sub_Systems( '/', me, children )
        
    ##-------------------------------------------------------------------------------------------------
    def _get_sub_Systems( self, parent, me, children ):
        
        if self.Systems[ parent ] == '':
            self.Systems[ me ] = '/'
            
        else:
            self.Systems[ me ] = self._connect_paths( ( self.Systems[ parent ], parent ) )
        
        for child, grandchildren in children.iteritems():
            self._get_sub_Systems( me, child, grandchildren )
        
    ##-------------------------------------------------------------------------------------------------
    def _get_Variables( self, CellML ):
        
        for actual, properties in CellML.grobal_variables.iteritems():
            
            path, ID = actual
            
            if properties[ 'variable' ].has_key( 'initial_value' ):
                self.Variables.append( Variable( 
                    self._connect_paths( ( self.Systems[ path ], path ) ),
                    ID,
                    properties[ 'variable' ][ 'initial_value' ] ) )
            
            else:
                self.Variables.append( Variable( 
                    self._connect_paths( ( self.Systems[ path ], path ) ),
                    ID ) )
            
#            print 'Variable:%s:%s' % ( self.Variables[ -1 ].path, ID )
    
    ##-------------------------------------------------------------------------------------------------
    def _get_Processes( self, CellML ):
        
        for c_name, c_property in CellML.components.iteritems():
            
            variables = [ self._get_grobal_variable( v, c_name, CellML ) for v in c_property[ 'variable' ] ]
            math      = [ m for m in c_property[ 'math' ] ]
            path      = self._connect_paths( ( self.Systems[ c_name ], c_name ) )
            
#            print '\nSystem: %s' % c_name
#            print 'variables: %s' % variables
            
            [ self._append_Process( m, variables, path ) for m in math ]
    
    ##-------------------------------------------------------------------------------------------------
    def _get_grobal_variable( self, variable, component, CellML ):
        
        for grobal_variable, pr in CellML.grobal_variables.iteritems():
            
            for local_variable in pr[ 'connection' ]:
                if ( local_variable[ 'component' ] == component ) and ( local_variable[ 'variable' ] == variable ):
                    path, ID = grobal_variable
                    return ( variable, self._connect_paths( ( self.Systems[ path ], path ) ), ID )
        
        return ( variable, False, False )
    
    ##-------------------------------------------------------------------------------------------------
    def _append_Process( self, math, variables, path ):
        
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
        
        Expression, VariableReferenceList = self._get_Expression_and_VariableReferenceList( math, variables )
        
        self.Processes.append( Process( cls, path, ID, VariableReferenceList, Expression ) )
        print '\n%s:%s:%s' % ( self.Processes[ -1 ].cls, self.Processes[ -1 ].path, self.Processes[ -1 ].ID )
        print '    %s' % self.Processes[ -1 ].Expression
        print '    %s\n' % self.Processes[ -1 ].VariableReferenceList
    
    ##-------------------------------------------------------------------------------------------------
    def _get_Expression_and_VariableReferenceList( self, math, variables ):
        
        math_Element = deepcopy( math.right_side )
        
        VariableReferenceList = [ list( v ) for v in variables 
            if ( v[ 0 ] in [ ci.text for ci in math_Element.findall( './/' + math.tag[ 'ci' ] ) ] ) ]
        
        for vr in VariableReferenceList:
            if math.variable == vr[ 0 ]:
                vr.append( 1 )
            else:
                vr.append( 0 )
        
        for v in variables:
            for ci in math_Element.iterfind( './/' + math.tag[ 'ci' ] ):
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
        paths = _paths
        
        if paths[ 0 ] in self.Entity_type_strings:
            paths( 0 )
        
        paths = [ p for p in paths if p != '' ]
        
        if paths == []:
            return '/'
        elif not ( paths[ 0 ] in ( '.', '..' ) ):
            paths.insert( 0, '' )
        
        return '/'.join( paths )


class Variable( object ):
        
    def __init__( self, path, ID, Value = False, Name = '' ):
        
        self.path  = path
        self.ID    = ID
        self.Value = Value
        self.Name  = Name
        


class Process( object ):
        
    def __init__( self, cls, path, ID, VariableReferenceList, Expression = '0.0', Name = '' ):
        
        self.cls        = cls
        self.path       = path
        self.ID         = ID
        self.Expression = Expression
        self.Name       = Name
        self.VariableReferenceList = []



########  MAIN  ########

CM = CellML( './tentusscher_noble_noble_panfilov_2004_a.cellml' )

#print CM.root_node.tag
#print CM.root_node.attrib

#print 'namespace: %s' % CM.namespace
#print '\n\ncomponent:\n%s' % CM.components
#print '\n\nvariable:\n%s' % CM.grobal_variables
#print '\n\ncontainment_hierarchies:\n%s' % CM.containment_hierarchies
#print '\n\nconnections:\n%s' % CM.connections

for component in CM.components.itervalues():
    for math in component[ 'math' ]:
#       print '\n' + math.get_expression_str()
       pass

model = ecell3Model( CM )

for component, FullID in model.Systems.iteritems():
    #print '{} : {}'.format( component, FullID )
    pass
