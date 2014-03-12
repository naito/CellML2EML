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

__program__   = 'CellML'
__version__   = '0.1'
__author__    = 'Yasuhiro Naito <ynaito@e-cell.org>'
__copyright__ = 'Keio University, RIKEN'
__license__   = 'GPL'

## ------------------------------------------
## 定数：名前空間
## ------------------------------------------
CELLML_NAMESPACE_1_0  = 'http://www.cellml.org/cellml/1.0#'
CELLML_NAMESPACE_1_1  = 'http://www.cellml.org/cellml/1.1#'
MATHML_NAMESPACE      = 'http://www.w3.org/1998/Math/MathML'


## ------------------------------------------
## 定数：方程式の型
## ------------------------------------------
CELLML_MATH_ALGEBRAIC_EQUATION  = 0
CELLML_MATH_ASSIGNMENT_EQUATION = 1
CELLML_MATH_RATE_EQUATION       = 2

CELLML_MATH_LEFT_SIDE  = 10
CELLML_MATH_RIGHT_SIDE = 11


import xml.etree.ElementTree as et
from xml.etree.ElementTree import XMLParser

from copy import deepcopy

class CellML( object ):

    def __init__( self, CellML_file_path ):
        
        parser = XMLParser()
        parser.feed( open( CellML_file_path, 'r' ).read() )

        self.root_node = parser.close()  ## xml.etree.ElementTree.Element object

        if self.root_node.tag == '{http://www.cellml.org/cellml/1.0#}model':
            self.namespace = 'http://www.cellml.org/cellml/1.0#'
        elif self.root_node.tag == '{http://www.cellml.org/cellml/1.1#}model':
            self.namespace =  'http://www.cellml.org/cellml/1.1#'
        else:
            raise TypeError, "CellML version is not specified."

        self.tag = dict(
            
            component        = '{%s}component' % self.namespace,
            variable         = '{%s}variable' % self.namespace,
            group            = '{%s}group' % self.namespace,
            relationship_ref = '{%s}relationship_ref' % self.namespace,
            component_ref    = '{%s}component_ref' % self.namespace,
            connection       = '{%s}connection' % self.namespace,
            map_components   = '{%s}map_components' % self.namespace,
            map_variables    = '{%s}map_variables' % self.namespace,

            math       = '{{{}}}math'.format( MATHML_NAMESPACE ),
            apply      = '{{{}}}apply'.format( MATHML_NAMESPACE ),
            math_apply = '{{{0}}}math/{{{0}}}apply'.format( MATHML_NAMESPACE ),
        )

        # print self.tag

        self.components = {}
        self.variable_attributes = ( 'initial_value', 'public_interface', 'private_interface', 'units' )
        self.containment_hierarchies = {} ## encapsulation は要素間の隠蔽関係の定義なので、E-Cell 3 では記述対象外
        self.connections = []
        
        self.grobal_variables = {}

        self._get_components()
        self._get_containment_hierarchies()
        self._get_connections()

        self._get_variables()


    ##-------------------------------------------------------------------------------------------------
    def _get_components( self ):
        
        ## <component> を探し、辞書 self.components に追加する。
        ##
        ## self.components[ name ] = {
        ##     variable : { name : [ public_interface, units ],... },
        ##     math     : [ mathML ],
        ## }
        
        
        for component_node in self.root_node.iterfind( './/' + self.tag[ 'component' ] ):
            
            if not self._has_name( component_node ):
                raise TypeError, "Component must have name attribute."
            
            self.components[ component_node.get( 'name' ) ] = dict( 
                variable = {},
                public_interface = 'none',
                private_interface = 'none',
                math = [] )
            
            ## variables
            
            for variable_node in component_node.iterfind( './/' + self.tag[ 'variable' ] ):
                
                if not self._has_name( variable_node ):
                    raise TypeError, "Variable must have name attribute. ( in component: %s )" % component_node.get( 'name' )
                
                self.set_component_variable( component_node, variable_node )
            
                # self._update_variable( variable_node )
            
            ## math
            
            for eq in component_node.findall( './/' + self.tag[ 'math_apply' ] ):
                self.components[ component_node.get( 'name' ) ][ 'math' ].append( MathML( eq ) )

    ##-------------------------------------------------------------------------------------------------
    def _get_containment_hierarchies( self ):
        
        ## <group/relationship_ref relationship="containment"> を探し、
        ## <componet> の階層構造を辞書 self.containment_hierarchies に格納する。
        ##
        ## { comp_1 : 
        ##     { comp_2 : 
        ##         { comp_3 : {},
        ##           comp_4 : {}
        ##         }
        ##       comp_5 : {},
        ##       comp_6 : {}
        ## }

        for group_node in self.root_node.iterfind( './/' + self.tag[ 'group' ] ):
            
            if group_node.find( './/' + self.tag[ 'relationship_ref' ] ) == None:
                raise TypeError, "<group> must have <relationship_ref> sub node."
            
            if group_node.find( './/' + self.tag[ 'relationship_ref' ] ).get( 'relationship' ) == 'containment':
                for top_level_component_ref in group_node.iterfind( './' + self.tag[ 'component_ref' ] ):
                    
                    if top_level_component_ref.get( 'component' ) == None:
                        raise TypeError, "<component_ref> must have 'component' attribute."
                    
                    # print top_level_component_ref.get( 'component' )
                    self.containment_hierarchies[ top_level_component_ref.get( 'component' ) ] = \
                        self._get_component_ref_dict( top_level_component_ref )
        
        # <group>に含まれないcomponentをトップレベルに追加
        for component_name in self.components:
            if self.exists_in_group( component_name ) == False:
                self.containment_hierarchies[ component_name ] = {}
            
    def exists_in_group( self, component_name ):
        
        for group_node in self.root_node.iterfind( './/' + self.tag[ 'group' ] ):
            if group_node.find( './/' + self.tag[ 'relationship_ref' ] ).get( 'relationship' ) == 'containment':
                for component_ref_node in group_node.iterfind( './/' + self.tag[ 'component_ref' ] ):
                     if component_name == component_ref_node.get( 'component' ):
                         return True
        return False


    ##-------------------------------------------------------------------------------------------------
    def _get_connections( self ):
        
        ## <connection> を探し、variableの同一関係をリスト self.connection に格納する。
        ##
        ## [ [ [ component_1, variable_1 ], [ component_2, variable_2 ],... ],... ]
        ##
        ## 他のvariableとconnectionを持つ場合、
        ##     self.components[ x ][ 'variable' ][ y ][ 'connection' ] = True
        ## に書き換える。
        
        for connection_node in self.root_node.iterfind( './/' + self.tag[ 'connection' ] ):
            
            map_components = connection_node.find( './/' + self.tag[ 'map_components' ] )
            map_variables_iter  = connection_node.iterfind( './/' + self.tag[ 'map_variables' ] )
            
            if None in ( map_components, map_variables_iter ):
                raise TypeError, "<connection> must have both of <map_components> and <map_variables> sub nodes."
            
            for map_variables in map_variables_iter:
                connection_map = [ dict( component = map_components.get( 'component_1' ),
                                         variable  = map_variables.get( 'variable_1' ) ),
                                   dict( component = map_components.get( 'component_2' ),
                                         variable  = map_variables.get( 'variable_2' ) ) ]
                
                existing_connection_map = self._exists_in_connections( connection_map )
                if existing_connection_map != False:
                    for connection_element in connection_map:
                        exists = False
                        for existing_connection in existing_connection_map:
                            if connection_element == existing_connection:
                                exists = True
                        if not exists:
                            existing_connection_map.append( connection_element )
                            self._set_componet_variable_connection_true( connection_element )
                
                else:
                    self.connections.append( connection_map )
                    for connection_element in connection_map:
                        self._set_componet_variable_connection_true( connection_element )
        
        

    ##-------------------------------------------------------------------------------------------------
    def _get_variables( self ):
        
        for component_name, component_element in self.components.iteritems():
            
            for variable_name, variable_element in component_element[ 'variable' ].iteritems():
                
                if not variable_element[ 'connection' ]:
                    
                    variable_ID = dict( component = component_name, variable  = variable_name )
                    
                    self.grobal_variables[ ( component_name, variable_name ) ] = dict(
                        variable   = variable_element,
                        connection = [ variable_ID ] )
        
        for connection_map in self.connections:
            
            actual = self._get_actual_properties_of_variable( connection_map )
            
            if actual:
                self.grobal_variables[ ( actual[ 'component' ], actual[ 'name' ] ) ] = dict(
                            variable   = actual[ 'variable' ],
                            connection = connection_map )

    ##-------------------------------------------------------------------------------------------------
    def _get_actual_properties_of_variable( self, connection_map ):
        
        actual = {}
        
        containing_component_IDs = []
        
        best_variable_ID = self._get_variable_with_initial_value( connection_map )
        
        if not best_variable_ID:
            best_variable_ID = dict(
                component = connection_map[ 0 ][ 'component' ],
                variable  = connection_map[ 0 ][ 'variable' ] )
        
        for variable_ID in connection_map:
            
            if self.components[ variable_ID[ 'component' ] ][ 'variable' ][ variable_ID[ 'variable' ] ][ 'public_interface' ] == 'out':
                
                containing_component_IDs.append( variable_ID )
        
        if len( containing_component_IDs ) == 0:
            
            return dict(
                component = '/',
                name      = best_variable_ID[ 'variable' ],
                variable  = self.components[ best_variable_ID[ 'component' ] ][ 'variable' ][ best_variable_ID[ 'variable' ] ] )
        
        elif len( containing_component_IDs ) == 1:
            
            return dict(
                component = containing_component_IDs[ 0 ][ 'component' ],
                name      = containing_component_IDs[ 0 ][ 'variable' ],
                variable  = self.components[ best_variable_ID[ 'component' ] ][ 'variable' ][ best_variable_ID[ 'variable' ] ] )
        
        else:
            actual_variable_ID = self._get_actual_variable_ID( containing_component_IDs )
            
            return dict(
                component = actual_variable_ID[ 'component' ],
                name      = actual_variable_ID[ 'variable' ],
                variable  = self.components[ best_variable_ID[ 'component' ] ][ 'variable' ][ best_variable_ID[ 'variable' ] ] )

    ##-------------------------------------------------------------------------------------------------
    def _get_actual_variable_ID( self, containing_component_IDs ):
        
        containing_components = [ ID[ 'component' ] for ID in containing_component_IDs ]
        score_dict = dict( [ ( c, 0 ) for c in containing_components ] )
        
        for component, sub_components in self.containment_hierarchies.iteritems():
            
            if component in containing_components:
                score_dict[ component ] += 1
            
            self._add_sub_components_score( score_dict, [ component ], sub_components, containing_components )
        
        max_score = 0
        actual_component = None
        
#        print 'Actual extraction: %s' % score_dict
        
        for component, score in score_dict.iteritems():
            
            if score > max_score:
                max_score = score
                actual_component = component
        
        for ID in containing_component_IDs:
            
            if ID[ 'component' ] == actual_component:
                
#                print '                 : %s' % ID
                return ID


    ##-------------------------------------------------------------------------------------------------
    def _add_sub_components_score( self, score_dict, parents, components, containing_components ):
        
        for component, sub_components in components.iteritems():
            
            if component in containing_components:
                score_dict[ component ] += 1
                for parent in parents:
                    if parent in containing_components:
                        score_dict[ parent ] += 1
            
            if len( sub_components ) > 0:
                next_parents = deepcopy( parents )
                next_parents.append( component )
                self._add_sub_components_score( score_dict, next_parents, sub_components, containing_components )
            

    ##-------------------------------------------------------------------------------------------------
    def _get_variable_with_initial_value( self, connection_map ):
        
        hits = []
        
        for variable_ID in connection_map:
            if self.components[ variable_ID[ 'component' ] ][ 'variable' ][ variable_ID[ 'variable' ] ].has_key( 'initial_value' ):
                hits.append( variable_ID )
        
        if len( hits ) == 1:
            return hits[ 0 ]
        
        elif len( hits ) == 0:
            return False
        
        else:
            error_variable_str = []
            for variable_ID in hits:
                error_variable_str.append( '"%s/%s"' % ( variable_ID[ 'component' ], variable_ID[ 'variable' ] ) )
            
            raise TypeError, "Initial value is set more than once in ( %s )" % ", ".join( error_variable_str )

    ##-------------------------------------------------------------------------------------------------
    def _set_componet_variable_connection_true( self, connection_element ):
        
        self.components[ connection_element[ 'component' ] ][ 'variable' ][ connection_element[ 'variable' ] ][ 'connection' ] = True
        
    ##-------------------------------------------------------------------------------------------------
    def _exists_in_connections( self, connection_map ):
        
        for connection in connection_map:
            for existing_connection_map in self.connections:
                for existing_connection in existing_connection_map:
                    if connection == existing_connection:
                        return existing_connection_map
        return False

    ##-------------------------------------------------------------------------------------------------
    def _get_component_ref_dict( self, component_ref_node ):
        
        component_ref_dict = {}
        
        for child_component_ref_node in component_ref_node.iterfind( './' + self.tag[ 'component_ref' ] ):
            if child_component_ref_node.get( 'component' ) == None:
                raise TypeError, "<component_ref> must have 'component' attribute."
            
            component_ref_dict[ child_component_ref_node.get( 'component' ) ] = self._get_component_ref_dict( child_component_ref_node )
        
        return component_ref_dict

    ##-------------------------------------------------------------------------------------------------
    def set_component_variable( self, component_node, variable_node ):
        
        variable_dict = dict( 
            public_interface  = 'none',
            private_interface = 'none',
            connection        = False )
        for attrib in self.variable_attributes:
            if variable_node.get( attrib ):
                variable_dict[ attrib ] = variable_node.get( attrib )
        
        self.components[ component_node.get( 'name' ) ][ 'variable' ][ variable_node.get( 'name' ) ] = variable_dict

    ##-------------------------------------------------------------------------------------------------
    def _has_name( self, element ):
         if element.get( 'name' ):
             return True
         else:
             return False


##=====================================================================================================


class MathML( object ):

    class Expression( object ):
        
        def __init__( self, string = '', priority = 0 ):
            self.string = string
            self.priority = priority

    def __init__( self, MathML, type = None ):
        
        self.root_node = MathML                   ## xml.etree.ElementTree.Element object
        
        # self.left_side  = self._get_left_side_Element()    ## 左辺のElementオブジェクト
        # self.right_side = self._get_right_side_Element()   ## 右辺のElementオブジェクト
        
        # CellML 1.0 で使用できる MathML タグ（https://www.cellml.org/specifications/cellml_1.0/index_html#sec_mathematics）
        self.tag = {
            
            'math' : '{{{0}}}math'.format( MATHML_NAMESPACE ),
            
          # token elements
            'cn' : '{{{0}}}cn'.format( MATHML_NAMESPACE ),
            'ci' : '{{{0}}}ci'.format( MATHML_NAMESPACE ),
            
          # basic content elements
            'apply'     : '{{{0}}}apply'.format( MATHML_NAMESPACE ),
            'piecewise' : '{{{0}}}piecewise'.format( MATHML_NAMESPACE ),
            'piece'     : '{{{0}}}piece'.format( MATHML_NAMESPACE ),
            'otherwise' : '{{{0}}}otherwise'.format( MATHML_NAMESPACE ),
            
          # relational operators
            'eq'  : '{{{0}}}eq'.format( MATHML_NAMESPACE ),
            'neq' : '{{{0}}}neq'.format( MATHML_NAMESPACE ),
            'gt'  : '{{{0}}}gt'.format( MATHML_NAMESPACE ),
            'lt'  : '{{{0}}}lt'.format( MATHML_NAMESPACE ),
            'geq' : '{{{0}}}geq'.format( MATHML_NAMESPACE ),
            'leq' : '{{{0}}}leq'.format( MATHML_NAMESPACE ),
            
          # arithmetic operators
            'plus'      : '{{{0}}}plus'.format( MATHML_NAMESPACE ),
            'minus'     : '{{{0}}}minus'.format( MATHML_NAMESPACE ),
            'times'     : '{{{0}}}times'.format( MATHML_NAMESPACE ),
            'divide'    : '{{{0}}}divide'.format( MATHML_NAMESPACE ),
            'power'     : '{{{0}}}power'.format( MATHML_NAMESPACE ),
            'root'      : '{{{0}}}root'.format( MATHML_NAMESPACE ),
            'abs'       : '{{{0}}}abs'.format( MATHML_NAMESPACE ),
            'exp'       : '{{{0}}}exp'.format( MATHML_NAMESPACE ),
            'ln'        : '{{{0}}}ln'.format( MATHML_NAMESPACE ),
            'log'       : '{{{0}}}log'.format( MATHML_NAMESPACE ),
            'floor'     : '{{{0}}}floor'.format( MATHML_NAMESPACE ),
            'ceiling'   : '{{{0}}}ceiling'.format( MATHML_NAMESPACE ),
            'factorial' : '{{{0}}}factorial'.format( MATHML_NAMESPACE ),
            
          # logical operators
            'and' : '{{{0}}}and'.format( MATHML_NAMESPACE ),
            'or'  : '{{{0}}}or'.format( MATHML_NAMESPACE ),
            'xor' : '{{{0}}}xor'.format( MATHML_NAMESPACE ),
            'not' : '{{{0}}}not'.format( MATHML_NAMESPACE ),
            
          # calculus elements
            'diff' : '{{{0}}}diff'.format( MATHML_NAMESPACE ),
            
          # qualifier elements
            'degree'  : '{{{0}}}degree'.format( MATHML_NAMESPACE ),
            'bvar'    : '{{{0}}}bvar'.format( MATHML_NAMESPACE ),
            'logbase' : '{{{0}}}logbase'.format( MATHML_NAMESPACE ),
            
          # trigonometric operators
            'sin'     : '{{{0}}}sin'.format( MATHML_NAMESPACE ),
            'cos'     : '{{{0}}}cos'.format( MATHML_NAMESPACE ),
            'tan'     : '{{{0}}}tan'.format( MATHML_NAMESPACE ),
            'sec'     : '{{{0}}}sec'.format( MATHML_NAMESPACE ),
            'csc'     : '{{{0}}}csc'.format( MATHML_NAMESPACE ),
            'cot'     : '{{{0}}}cot'.format( MATHML_NAMESPACE ),
            'sinh'    : '{{{0}}}sinh'.format( MATHML_NAMESPACE ),
            'cosh'    : '{{{0}}}cosh'.format( MATHML_NAMESPACE ),
            'tanh'    : '{{{0}}}tanh'.format( MATHML_NAMESPACE ),
            'sech'    : '{{{0}}}sech'.format( MATHML_NAMESPACE ),
            'csch'    : '{{{0}}}csch'.format( MATHML_NAMESPACE ),
            'coth'    : '{{{0}}}coth'.format( MATHML_NAMESPACE ),
            'arcsin'  : '{{{0}}}arcsin'.format( MATHML_NAMESPACE ),
            'arccos'  : '{{{0}}}arccos'.format( MATHML_NAMESPACE ),
            'arctan'  : '{{{0}}}arctan'.format( MATHML_NAMESPACE ),
            'arccosh' : '{{{0}}}arccosh'.format( MATHML_NAMESPACE ),
            'arccot'  : '{{{0}}}arccot'.format( MATHML_NAMESPACE ),
            'arccoth' : '{{{0}}}arccoth'.format( MATHML_NAMESPACE ),
            'arccsc'  : '{{{0}}}arccsc'.format( MATHML_NAMESPACE ),
            'arccsch' : '{{{0}}}arccsch'.format( MATHML_NAMESPACE ),
            'arcsec'  : '{{{0}}}arcsec'.format( MATHML_NAMESPACE ),
            'arcsech' : '{{{0}}}arcsech'.format( MATHML_NAMESPACE ),
            'arcsinh' : '{{{0}}}arcsinh'.format( MATHML_NAMESPACE ),
            'arctanh' : '{{{0}}}arctanh'.format( MATHML_NAMESPACE ),
            
          # constants
            'true'         : '{{{0}}}true'.format( MATHML_NAMESPACE ),
            'false'        : '{{{0}}}false'.format( MATHML_NAMESPACE ),
            'notanumber'   : '{{{0}}}notanumber'.format( MATHML_NAMESPACE ),
            'pi'           : '{{{0}}}pi'.format( MATHML_NAMESPACE ),
            'infinity'     : '{{{0}}}infinity'.format( MATHML_NAMESPACE ),
            'exponentiale' : '{{{0}}}exponentiale'.format( MATHML_NAMESPACE ),
            
          # semantics and annotation elements
            'semantics'      : '{{{0}}}semantics'.format( MATHML_NAMESPACE ),
            'annotation'     : '{{{0}}}annotation'.format( MATHML_NAMESPACE ),
            'annotation-xml' : '{{{0}}}annotation-xml'.format( MATHML_NAMESPACE ),
            
        }
        
        
        ## ----------------------------------------
        ## MathMLのグループ  self.tag_group
        ## 反復処理のコードの簡略化のため
        ## ----------------------------------------
        # 
        self.tag_group = {

           # --------------------------------------------------------------------
           # 数式処理によるグループ
           # 未実装：degree, bvar, logbase, semantics, annotation, annotation-xml
           # --------------------------------------------------------------------
            'unary_func' : [ 
                self.tag[ 'not' ],
                
                self.tag[ 'abs' ],
                self.tag[ 'floor' ],
                self.tag[ 'ceiling' ],
                self.tag[ 'factorial' ],
                self.tag[ 'exp' ],
                self.tag[ 'ln' ],
                self.tag[ 'log' ],

                self.tag[ 'sin' ],
                self.tag[ 'cos' ],
                self.tag[ 'tan' ],
                self.tag[ 'sec' ],
                self.tag[ 'csc' ],
                self.tag[ 'cot' ],
                self.tag[ 'sinh' ],
                self.tag[ 'cosh' ],
                self.tag[ 'tanh' ],
                self.tag[ 'sech' ],
                self.tag[ 'csch' ],
                self.tag[ 'coth' ],
                self.tag[ 'arcsin' ],
                self.tag[ 'arccos' ],
                self.tag[ 'arctan' ],
                self.tag[ 'arccosh' ],
                self.tag[ 'arccot' ],
                self.tag[ 'arccoth' ],
                self.tag[ 'arccsc' ],
                self.tag[ 'arccsch' ],
                self.tag[ 'arcsec' ],
                self.tag[ 'arcsech' ],
                self.tag[ 'arcsinh' ],
                self.tag[ 'arctanh' ], ],

            'unary_binary_func' : [ 
                self.tag[ 'root' ], ],

            'binary_func' : [ 
                self.tag[ 'neq' ],
                self.tag[ 'power' ], ],

            'nary_chain_func' : [ 
                self.tag[ 'eq' ],
                self.tag[ 'gt' ],
                self.tag[ 'lt' ],
                self.tag[ 'geq' ],
                self.tag[ 'leq' ], ],

            'nary_nest_func' : [ 
                self.tag[ 'and' ],
                self.tag[ 'or' ],
                self.tag[ 'xor' ], ],

            'unary_binary_arith' : [ 
                self.tag[ 'minus' ], ],

            'binary_arith' : [ 
                self.tag[ 'divide' ], ],

            'nary_arith' : [ 
                self.tag[ 'times' ],
                self.tag[ 'plus' ], ],

            'piecewise' : [ 
                self.tag[ 'piecewise' ],
                self.tag[ 'piece' ],
                self.tag[ 'otherwise' ] ],

           # --------------------------------------------------------------------
           # タグの性格による分類
           # --------------------------------------------------------------------
            'token' : [ 
                self.tag[ 'cn' ],           # 数字
                self.tag[ 'ci' ] ],         # 識別子

            'basic_content' : [ 
                self.tag[ 'apply' ],        # 演算子適用宣言（直後には演算子）
                self.tag[ 'piecewise' ],
                self.tag[ 'piece' ],
                self.tag[ 'otherwise' ] ],

            'relational_operators' : [ 
                self.tag[ 'eq' ],           # 等号と比較演算子の区別はどうつけているのだろう？？？
                self.tag[ 'neq' ],          
                self.tag[ 'gt' ],
                self.tag[ 'lt' ],
                self.tag[ 'geq' ],
                self.tag[ 'leq' ] ],

            'arithmetic_operators' : [ 
                self.tag[ 'plus' ],
                self.tag[ 'minus' ],
                self.tag[ 'times' ],
                self.tag[ 'divide' ],
                self.tag[ 'power' ],
                self.tag[ 'root' ],
                self.tag[ 'abs' ],
                self.tag[ 'exp' ],
                self.tag[ 'ln' ],
                self.tag[ 'log' ],
                self.tag[ 'floor' ],
                self.tag[ 'ceiling' ],
                self.tag[ 'factorial' ] ],

            'logical_operators' : [ 
                self.tag[ 'and' ],
                self.tag[ 'or' ],
                self.tag[ 'xor' ],
                self.tag[ 'not' ] ],

            'calculus' : [ 
                self.tag[ 'diff' ] ],       # 微分演算子

            'qualifier' : [ 
                self.tag[ 'degree' ],       # 次数
                self.tag[ 'bvar' ],         # 変数の結合（dv/dtなど）
                self.tag[ 'logbase' ] ],    # 対数の底

            'trigonometric_operators' : [ 
                self.tag[ 'sin' ],
                self.tag[ 'cos' ],
                self.tag[ 'tan' ],
                self.tag[ 'sec' ],
                self.tag[ 'csc' ],
                self.tag[ 'cot' ],
                self.tag[ 'sinh' ],
                self.tag[ 'cosh' ],
                self.tag[ 'tanh' ],
                self.tag[ 'sech' ],
                self.tag[ 'csch' ],
                self.tag[ 'coth' ],
                self.tag[ 'arcsin' ],
                self.tag[ 'arccos' ],
                self.tag[ 'arctan' ],
                self.tag[ 'arccosh' ],
                self.tag[ 'arccot' ],
                self.tag[ 'arccoth' ],
                self.tag[ 'arccsc' ],
                self.tag[ 'arccsch' ],
                self.tag[ 'arcsec' ],
                self.tag[ 'arcsech' ],
                self.tag[ 'arcsinh' ],
                self.tag[ 'arctanh' ] ],

            'constants' : [ 
                self.tag[ 'true' ],
                self.tag[ 'false' ],
                self.tag[ 'notanumber' ],
                self.tag[ 'pi' ],
                self.tag[ 'infinity' ],
                self.tag[ 'exponentiale' ] ],

            'semantics_annotation' : [ 
                self.tag[ 'semantics' ],
                self.tag[ 'annotation' ],
                self.tag[ 'annotation-xml' ] ]
        }
        
        
        ## ------------------------------------------------
        ## 演算子のExpression属性中での表現 self.operator_str
        ## ------------------------------------------------
        self.operator_str = {
          # basic content elements
            self.tag[ 'piecewise' ] : 'piecewise',
            # self.tag[ 'piece' ] : 'piece',
            # self.tag[ 'otherwise' ] : 'otherwise',
            
          # relational operators
            self.tag[ 'eq' ]  : 'eq',
            self.tag[ 'neq' ] : 'neq',
            self.tag[ 'gt' ]  : 'gt',
            self.tag[ 'lt' ]  : 'lt',
            self.tag[ 'geq' ] : 'geq',
            self.tag[ 'leq' ] : 'leq',
            
          # arithmetic operators
            self.tag[ 'plus' ]      : '+',
            self.tag[ 'minus' ]     : '-',
            self.tag[ 'times' ]     : '*',
            self.tag[ 'divide' ]    : '/',
            self.tag[ 'power' ]     : 'pow',
            self.tag[ 'root' ]      : 'sqrt',  # when Unary
            self.tag[ 'abs' ]       : 'abs',
            self.tag[ 'exp' ]       : 'exp',
            self.tag[ 'ln' ]        : 'ln',
            self.tag[ 'log' ]       : 'log',
            self.tag[ 'floor' ]     : 'floor',
            self.tag[ 'ceiling' ]   : 'ceiling',
            self.tag[ 'factorial' ] : 'factorial',
            
          # logical operators
            self.tag[ 'and' ] : 'and',
            self.tag[ 'or' ]  : 'or',
            self.tag[ 'xor' ] : 'xor',
            self.tag[ 'not' ] : 'not',
            
          # calculus elements
            self.tag[ 'diff' ] : 'diff',
            
          # qualifier elements
            self.tag[ 'degree' ]  : 'degree',
            self.tag[ 'bvar' ]    : 'bvar',
            self.tag[ 'logbase' ] : 'logbase',
            
          # trigonometric operators
            self.tag[ 'sin' ]     : 'sin',
            self.tag[ 'cos' ]     : 'cos',
            self.tag[ 'tan' ]     : 'tan',
            self.tag[ 'sec' ]     : 'sec',
            self.tag[ 'csc' ]     : 'csc',
            self.tag[ 'cot' ]     : 'cot',
            self.tag[ 'sinh' ]    : 'sinh',
            self.tag[ 'cosh' ]    : 'cosh',
            self.tag[ 'tanh' ]    : 'tanh',
            self.tag[ 'sech' ]    : 'sech',
            self.tag[ 'csch' ]    : 'csch',
            self.tag[ 'coth' ]    : 'coth',
            self.tag[ 'arcsin' ]  : 'arcsin',
            self.tag[ 'arccos' ]  : 'arccos',
            self.tag[ 'arctan' ]  : 'arctan',
            self.tag[ 'arccosh' ] : 'arccosh',
            self.tag[ 'arccot' ]  : 'arccot',
            self.tag[ 'arccoth' ] : 'arccoth',
            self.tag[ 'arccsc' ]  : 'arccsc',
            self.tag[ 'arccsch' ] : 'arccsch',
            self.tag[ 'arcsec' ]  : 'arcsec',
            self.tag[ 'arcsech' ] : 'arcsech',
            self.tag[ 'arcsinh' ] : 'arcsinh',
            self.tag[ 'arctanh' ] : 'arctanh',
            
          # constants
            self.tag[ 'true' ]         : 'true',
            self.tag[ 'false' ]        : 'false',
            self.tag[ 'notanumber' ]   : 'notanumber',
            self.tag[ 'pi' ]           : 'pi',
            self.tag[ 'infinity' ]     : 'infinity',
            self.tag[ 'exponentiale' ] : 'exponentiale',
            
          # semantics and annotation elements
            self.tag[ 'semantics' ]      : 'semantics',
            self.tag[ 'annotation' ]     : 'annotation',
            self.tag[ 'annotation-xml' ] : 'annotation-xml',
        }
        
        
        ## --------------------------------------
        ## 演算子の優先順位 self.operator_priority
        ## --------------------------------------
        self.operator_priority = {
          # token elements
            self.tag[ 'cn' ] : 8,
            self.tag[ 'ci' ] : 8,
            
          # basic content elements
            self.tag[ 'apply' ]     : 0,
            self.tag[ 'piecewise' ] : 8,
            self.tag[ 'piece' ]     : 0,
            self.tag[ 'otherwise' ] : 0,
            
          # relational operators
            self.tag[ 'eq' ]  : 0,
            self.tag[ 'neq' ] : 0,
            self.tag[ 'gt' ]  : 0,
            self.tag[ 'lt' ]  : 0,
            self.tag[ 'geq' ] : 0,
            self.tag[ 'leq' ] : 0,
            
          # arithmetic operators
            self.tag[ 'plus' ]      : 2,
            self.tag[ 'minus' ]     : 2,
            self.tag[ 'times' ]     : 4,
            self.tag[ 'divide' ]    : 4,
            self.tag[ 'power' ]     : 8,
            self.tag[ 'root' ]      : 8,
            self.tag[ 'abs' ]       : 8,
            self.tag[ 'exp' ]       : 8,
            self.tag[ 'ln' ]        : 8,
            self.tag[ 'log' ]       : 8,
            self.tag[ 'floor' ]     : 8,
            self.tag[ 'ceiling' ]   : 8,
            self.tag[ 'factorial' ] : 8,
            
          # logical operators
            self.tag[ 'and' ] : 8,
            self.tag[ 'or' ]  : 8,
            self.tag[ 'xor' ] : 8,
            self.tag[ 'not' ] : 8,
            
          # calculus elements
            self.tag[ 'diff' ] : 8,
            
          # qualifier elements
            self.tag[ 'degree' ]  : 0,
            self.tag[ 'bvar' ]    : 0,
            self.tag[ 'logbase' ] : 0,
            
          # trigonometric operators
            self.tag[ 'sin' ]     : 0,
            self.tag[ 'cos' ]     : 0,
            self.tag[ 'tan' ]     : 0,
            self.tag[ 'sec' ]     : 0,
            self.tag[ 'csc' ]     : 0,
            self.tag[ 'cot' ]     : 0,
            self.tag[ 'sinh' ]    : 0,
            self.tag[ 'cosh' ]    : 0,
            self.tag[ 'tanh' ]    : 0,
            self.tag[ 'sech' ]    : 0,
            self.tag[ 'csch' ]    : 0,
            self.tag[ 'coth' ]    : 0,
            self.tag[ 'arcsin' ]  : 0,
            self.tag[ 'arccos' ]  : 0,
            self.tag[ 'arctan' ]  : 0,
            self.tag[ 'arccosh' ] : 0,
            self.tag[ 'arccot' ]  : 0,
            self.tag[ 'arccoth' ] : 0,
            self.tag[ 'arccsc' ]  : 0,
            self.tag[ 'arccsch' ] : 0,
            self.tag[ 'arcsec' ]  : 0,
            self.tag[ 'arcsech' ] : 0,
            self.tag[ 'arcsinh' ] : 0,
            self.tag[ 'arctanh' ] : 0,
            
          # constants
            self.tag[ 'true' ]         : 0,
            self.tag[ 'false' ]        : 0,
            self.tag[ 'notanumber' ]   : 0,
            self.tag[ 'pi' ]           : 0,
            self.tag[ 'infinity' ]     : 0,
            self.tag[ 'exponentiale' ] : 0,
            
          # semantics and annotation elements
            self.tag[ 'semantics' ]      : 0,
            self.tag[ 'annotation' ]     : 0,
            self.tag[ 'annotation-xml' ] : 0,
        }
        
        
        ## ------------------------------------------
        ## 左辺の形式ごとのタグ構造のパターン
        ## 階層化せず、ベタに上から下へ読んだ場合のパターン
        ## ------------------------------------------
        self.tag_pattern = {
            CELLML_MATH_ASSIGNMENT_EQUATION : [ [ self.tag[ 'ci' ] ] ],
            CELLML_MATH_RATE_EQUATION       : [ [ self.tag[ 'apply' ], self.tag[ 'diff' ], self.tag[ 'bvar' ], self.tag[ 'ci' ], self.tag[ 'ci' ] ] ]
        }
    
        ## ------------------------------------------
        ## 方程式の型、従属変数
        ## ------------------------------------------
        if type:
            self.type = type
            self.variable = None
        else:
            self.type = self.get_equation_type()      ## 方程式の型。以下の定数のいずれかを持つ
            self.variable = self.get_equation_variable()
            self.right_side = self._get_right_side_Element()   ## 右辺のElement
            self.string = self.get_right_side().get_expression_str()    ## 右辺の式を文字列にしたもの→Expressionとして使うテンプレート
    
    ##-------------------------------------------------------------------------------------------------
    ## 左右の辺、方程式の型、従属変数の取得メソッド
    ##-------------------------------------------------------------------------------------------------
    def get_equation_type( self ):
        
        left_side_Element = self._get_left_side_Element()
        
        if left_side_Element == None:
            raise TypeError, "Left side of equation is not found."
        
        tags = []
        
        for element in left_side_Element.iter():
            
            tags.append( element.tag )
        
        for type, tag_pattern in self.tag_pattern.iteritems():
            if tags in tag_pattern:
                return type
        
        return False
    
    ##-------------------------------------------------------------------------------------------------
    def get_equation_variable( self ):
        
        left_side_Element = self._get_left_side_Element()
        
        if left_side_Element == None:
            raise TypeError, "Left side of equation is not found."
        
        if left_side_Element.tag == self.tag[ 'apply' ]:  # differential equasion
            return left_side_Element.findall( './*' ).pop().text
        else:
            return left_side_Element.text
        
        return False
    
    ##-------------------------------------------------------------------------------------------------
    def get_left_side( self ):
        return MathML( self._get_left_side_Element(), CELLML_MATH_LEFT_SIDE )
    
    ##-------------------------------------------------------------------------------------------------
    def _get_left_side_Element( self ):
        
        find_eq = False
        count = 0
        
        for element in self.root_node.iter():
            
            # print '\n_get_left_side_Element() type: %s\n' % type( element )
            
            if count == 0 and element.tag != self.tag[ 'apply' ]:
                return None
            
            elif count == 1 and element.tag != self.tag[ 'eq' ]:
                return None
            
            elif count == 2:
                if element.tag in ( self.tag[ 'apply' ], self.tag[ 'ci' ] ):
                    return element
                else:
                    return None
            
            else:
                count += 1
        
        return None
        
    ##-------------------------------------------------------------------------------------------------
    def get_right_side( self ):
        return MathML( self._get_right_side_Element(), CELLML_MATH_RIGHT_SIDE )
    
    ##-------------------------------------------------------------------------------------------------
    def _get_right_side_Element( self ):
        
        find_eq = False
        find_left_side = False
        
        for element in self.root_node.iterfind( './*' ):
            
            if element.tag == self.tag[ 'eq' ]:
                find_eq = True
            
            elif find_eq and ( not find_left_side ):
                find_left_side = True
            
            elif find_eq and find_left_side:
                
                return element
        
        return None
    
    ##-------------------------------------------------------------------------------------------------
    ## Elememtを文字列に変換するためのメソッド
    ##-------------------------------------------------------------------------------------------------
    def get_expression_str( self ):
        
        if self.type in ( CELLML_MATH_ALGEBRAIC_EQUATION,
                          CELLML_MATH_ASSIGNMENT_EQUATION,
                          CELLML_MATH_RATE_EQUATION ):
            
            return '%s = %s' % ( self.get_left_side().get_expression_str(),
                                 self.get_right_side().get_expression_str() )
        else:
            return self._convert_element_to_Expression( self.root_node ).string
    
    ##-------------------------------------------------------------------------------------------------
    def _convert_element_to_Expression( self, element ):
        
        if element.tag in self.tag_group[ 'token' ]:
            return self.Expression( element.text, self.operator_priority[ element.tag ] )
            
        elif element.tag == self.tag[ 'apply' ]:
            return self._convert_apply_element_to_Expression( element )
            
        elif element.tag == self.tag[ 'piecewise' ]:
            return self._convert_piecewise_element_to_Expression( element )
        
        else:
            return self.Expression( '((( %s,... )))' % self._get_tag_without_namespace( element.tag ), 255 )
    
    ##-------------------------------------------------------------------------------------------------
    def _convert_apply_element_to_Expression( self, element ):
        
        children = element.findall( './*' )
        
        operator = children.pop( 0 )
        return self._convert_applying_Elements_to_Expression( operator.tag, children )
        
        return self.Expression( '((( %s,... )))' % self._get_tag_without_namespace( operator.tag ), 255 )
    
    ##-------------------------------------------------------------------------------------------------
    def _convert_piecewise_element_to_Expression( self, element ):
        
        #pieces = element.findall( './piece' )
        #otherwise = element.findall( './otherwise' )
        #if len( otherwise ) > 1:
        #    raise TypeError, '<piecewise> element must have 0 or 1 <otherwise> child.'
        #
        #print 'piecewise: piece( %i ), otherwise( %i ), (total %i Elements)' % ( len( pieces ), len( otherwise ), len( element.findall( './*' ) ) )
        
        sub_elements = element.findall( './*' )
        
        piece_Expressions = []
        otherwise_Expression = None
        
        for sub_element in sub_elements:
            
            if sub_element.tag == self.tag[ 'piece' ]:
                
                children = sub_element.findall( './*' )
                
                if len( children ) != 2:
                    raise TypeError, '<piece> element must have exactly 2 children.'
                
                piece_Expressions.append( 
                    dict(
                        condition = self._convert_element_to_Expression( children.pop() ),
                        value     = self._convert_element_to_Expression( children.pop() )
                        )
                    )
            
            elif sub_element.tag == self.tag[ 'otherwise' ]:
                
                if otherwise_Expression:
                    raise TypeError, '<piecewise> element must have 0 or 1 <otherwise> child.'
                
                child = sub_element.findall( './*' )
                
                if len( child ) != 1:
                    raise TypeError, '<otherwise> element must have exactly 1 child.'
                
                otherwise_Expression = self._convert_element_to_Expression( child.pop() )
            
            else:
                raise TypeError, '<piecewise> element\'s child must be <piece> or <otherwise> element.'
            
        return self._arrange_piecewise_Expression( piece_Expressions, otherwise_Expression )
    
    ##-------------------------------------------------------------------------------------------------
    def _convert_applying_Elements_to_Expression( self, tag, children ):
       
        operator = None
       
        children_Expressions = []
       
        for child in children:
            children_Expressions.append( self._convert_element_to_Expression( child ) )
        
        # Unary arithmetic
        if tag  in self.tag_group[ 'unary_binary_arith' ] and len( children_Expressions ) == 1:
            
            return self.Expression( self.operator_str[ tag ] + self._get_parenthesized_expression_string( 8, children_Expressions[ 0 ] ), 8 )
        
        # Binary arithmetic
        elif tag == self.tag[ 'divide' ]:
            if len( children_Expressions ) != 2:
                raise TypeError, 'Operator "%s" must have exactly 2 children.' % self._get_tag_without_namespace( tag )
            
            children_expression_strings = ( 
                children_Expressions[ 0 ].string,
                self._get_parenthesized_expression_string( 8, children_Expressions[ 1 ] ) )
            operator = ' %s ' % self.operator_str[ tag ]
            return self.Expression( operator.join( children_expression_strings ), self.operator_priority[ tag ] )
        
        elif tag == self.tag[ 'minus' ]:
            if len( children_Expressions ) != 2:
                raise TypeError, 'Operator "%s" must have exactly 2 children.' % self._get_tag_without_namespace( tag )
            
            children_expression_strings = self._get_parenthesized_expression_strings( self.operator_priority[ tag ], children_Expressions )
            operator = ' %s ' % self.operator_str[ tag ]
            return self.Expression( operator.join( children_expression_strings ), self.operator_priority[ tag ] )
        
        # Nary arithmetic
        elif tag in self.tag_group[ 'nary_arith' ]:
            if len( children_Expressions ) < 2:
                raise TypeError, 'Operator "%s" must have >= 2 children.' % self._get_tag_without_namespace( tag )
            
            children_expression_strings = self._get_parenthesized_expression_strings( self.operator_priority[ tag ], children_Expressions )
            operator = ' %s ' % self.operator_str[ tag ]
            return self.Expression( operator.join( children_expression_strings ), self.operator_priority[ tag ] )
        
        # Unary function
        elif ( tag in self.tag_group[ 'unary_func' ] ) or \
             ( tag in self.tag_group[ 'unary_binary_func' ] and len( children_Expressions ) == 1 ):
            if len( children_Expressions ) != 1:
                raise TypeError, 'Operator "%s" must have exactly 1 child.' % self._get_tag_without_namespace( tag )
            
            return self.Expression( '%s( %s )' % ( self.operator_str[ tag ], 
                                                   children_Expressions[ 0 ].string ), 
                                    self.operator_priority[ tag ] )
        
        # Binary function
        elif tag in self.tag_group[ 'binary_func' ]:
            if len( children_Expressions ) != 2:
                raise TypeError, 'Operator "%s" must have exactly 2 children.' % self._get_tag_without_namespace( tag )
            
            children_expression_strings = self._get_parenthesized_expression_strings( 0, children_Expressions )
            
            format_strings = [ self.operator_str[ tag ] ]
            format_strings.extend( children_expression_strings )
            # print '\n_convert_applying_Elements_to_Expression::format_strings = %s\n' % format_strings
            return self.Expression( '%s( %s, %s )' % tuple( format_strings ), self.operator_priority[ tag ] )
        
        # Binary function - root
        elif tag == self.tag[ 'root' ]:
            if len( children_Expressions ) != 2:
                raise TypeError, 'Operator "%s" must have exactly 1 or 2 children.' % self._get_tag_without_namespace( tag )
            
            children_expression_strings = self._get_parenthesized_expression_strings( 0, children_Expressions )
            
            format_strings = ( 'pow', 
                               children_expression_strings[ 0 ], 
                               '1 / %s' % self._get_parenthesized_expression_string( 8, children_expression_strings[ 1 ] ) )
            return self.Expression( '%s( %s, %s )' % format_strings, self.operator_priority[ tag ] )
        
        # Nary nest function
        elif tag in self.tag_group[ 'nary_nest_func' ]:
            if len( children_Expressions ) < 2:
                raise TypeError, 'Operator "%s" must have >=2 children.' % self._get_tag_without_namespace( tag )
            
            children_expression_strings = self._get_parenthesized_expression_strings( 0, children_Expressions )
            
            return_string = '%s( %s, %s )' % ( self.operator_str[ tag ], 
                                               children_expression_strings.pop( 0 ), 
                                               children_expression_strings.pop( 0 ) )
            
            while len( children_expression_strings ):
                
                return_string = '%s( %s, %s )' % ( self.operator_str[ tag ], 
                                                   return_string, 
                                                   children_expression_strings.pop( 0 ) )
            
            return self.Expression( return_string, self.operator_priority[ tag ] )
        
        # Nary chain function
        elif tag in self.tag_group[ 'nary_chain_func' ]:
            if len( children_Expressions ) < 2:
                raise TypeError, 'Operator "%s" must have >=2 children.' % self._get_tag_without_namespace( tag )
            
            children_expression_strings = self._get_parenthesized_expression_strings( 0, children_Expressions )
            
            child_1 = children_expression_strings.pop( 0 )
            child_2 = children_expression_strings.pop( 0 )
            
            chain = []
            
            chain.append( '%s( %s, %s )' % ( self.operator_str[ tag ], child_1, child_2 ) )
            
            while len( children_expression_strings ):
                child_1 = child_2
                child_2 = children_expression_strings.pop( 0 )
                chain.append( '%s( %s, %s )' % ( self.operator_str[ tag ], child_1, child_2 ) )
            
            if len( chain ) == 1:
                return self.Expression( chain.pop(), self.operator_priority[ tag ] )
            
            else:
                chained_string = 'and( %s, %s )' % ( chain.pop( 0 ), chain.pop( 0 ) )
                
                while len( chain ):
                    chained_string = 'and( %s, %s )' % ( chained_string, chain.pop( 0 ) )
                
                return elf.Expression( chained_string, self.operator_priority[ self.tag[ 'and' ] ] )
        
        # diff
        elif tag == self.tag[ 'diff' ]:
            if len( children_Expressions ) != 2:
                raise TypeError, '"diff" element must have exactly 2 children.'
            
            ci   = children.pop().text
            bvar = children.pop()
            
            if bvar.findall( './*' ).pop().text == 'time':
                return self.Expression( 'd(%s)/dt' % ci, self.operator_priority[ tag ] )
            else:
                return self.Expression( 'd(%s)/d(%s)' % ( ci, bvar.findall( './*' ).pop().text ), self.operator_priority[ tag ] )
        
        return self.Expression( '((( %s,... )))' % self._get_tag_without_namespace( tag ), 255 )
    
    ##-------------------------------------------------------------------------------------------------
    def _get_parenthesized_expression_strings( self, operator_priorty, Expressions ):
        
        parenthesized_expression_strings = []
        
        for Expression in Expressions:
            parenthesized_expression_strings.append( self._get_parenthesized_expression_string( operator_priorty, Expression ) )
        
        return parenthesized_expression_strings
    
    ##-------------------------------------------------------------------------------------------------
    def _get_parenthesized_expression_string( self, operator_priorty, Expression ):
        
        if operator_priorty > Expression.priority:
            return '( %s )' % Expression.string
        else:
            return Expression.string
    
    ##-------------------------------------------------------------------------------------------------
    def _arrange_piecewise_Expression( self, piece_Expressions, otherwise_Expression ):
        
        args = []
        
        for piece in piece_Expressions:
            args.append( piece[ 'value' ].string )
            args.append( piece[ 'condition' ].string )
        
        if otherwise_Expression:
            args.append( otherwise_Expression.string )
        
        args = ', '.join( args )
        
        return self.Expression( '%s( %s )' % ( self.operator_str[ self.tag[ 'piecewise' ] ], args ), 
                                self.operator_priority[ self.tag[ 'piecewise' ] ] )
    
    ##-------------------------------------------------------------------------------------------------
    def _get_tag_without_namespace( self, tag ):
        return tag.split( '}' ).pop()
