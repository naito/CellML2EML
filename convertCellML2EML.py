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


class ecell3Model( object ):
    
    def __init__( self, CellML ):
        
        self.Entity_type_strings = [ 'System', 'Variable', 'Process', 'Stepper' ]
        
        self.Systems   = self._getSystems( CellML )
        
        #print self.Systems
        
        self.Variables = self._getVariables( CellML )
    
    ##-------------------------------------------------------------------------------------------------
    def _getSystems( self, CellML ):
        
        _Systems = { '/' : '' }  ## component (ID) : ecell3_path
        
        for me, children in CellML.containment_hierarchies.iteritems():
            
            self._getSubSystems( _Systems, '/', me, children )
        
        return _Systems
        
    ##-------------------------------------------------------------------------------------------------
    def _getSubSystems( self, _Systems, parent, me, children ):
        
        if _Systems[ parent ] == '':
            _Systems[ me ] = '/'
            
        elif _Systems[ parent ] == '/':
            _Systems[ me ] = '/' + parent
            
        else:
            _Systems[ me ] = self._connect_paths( ( _Systems[ parent ], parent ) )
        
        #print 'System:%s:%s' % ( _Systems[ me ], me )
        
        for child, grandchildren in children.iteritems():
            self._getSubSystems( _Systems, me, child, grandchildren )
        
        return _Systems
        
    ##-------------------------------------------------------------------------------------------------
    def _getVariables( self, CellML ):
        
        _Variables = {}
        
        for actual, properties in CellML.unique_variables.iteritems():
            
            _Variables[ actual[ 1 ] ] = dict( 
                superSystem   = 'System:{}:{}'.format( self._connect_paths( self.Systems[ actual[ 0 ] ] ), actual[ 0 ] ),
                initial_value = None )
            
            if properties[ 'variable' ].has_key( 'initial_value' ):
                _Variables[ actual[ 1 ] ][ 'initialValue' ] = properties[ 'variable' ][ 'initial_value' ]
            
            print 'Variable:%s:%s' % ( _Variables[ actual[ 1 ] ][ 'superSystem' ], actual[ 1 ] )
            
        return _Variables
    
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
        
        floors = []
        
        for el in paths:
            floors.extend( el.split( '/' ) )
        
        if floors[ 0 ] in self.Entity_type_strings:
            floors.pop( 0 )
        
        if floors == [ '' ]:
            return '/'
        else:
            return '/'.join( floors )


########  MAIN  ########

CM = CellML( './tentusscher_noble_noble_panfilov_2004_a.cellml' )

#print CM.root_node.tag
#print CM.root_node.attrib

#print 'namespace: %s' % CM.namespace
#print '\n\ncomponent:\n%s' % CM.components
#print '\n\nvariable:\n%s' % CM.unique_variables
print '\n\ncontainment_hierarchies:\n%s' % CM.containment_hierarchies
#print '\n\nconnections:\n%s' % CM.connections

for component in CM.components.itervalues():
    for math in component[ 'math' ]:
#       print '\n' + math.get_expression_str()
       pass

model = ecell3Model( CM )

for component, FullID in model.Systems.iteritems():
    print '{} : {}'.format( component, FullID )
