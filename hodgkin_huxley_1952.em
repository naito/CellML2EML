
# created by eml2em program
# from file: hodgkin_huxley_1952.eml, date: Sun Mar 16 10:31:05 2014
#

Stepper FixedODE1Stepper( ODE )
{
	# no property
}

Stepper DiscreteTimeStepper( DT )
{
	# no property
}

System System( / )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	
}

System System( /environment )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( time )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	
}

System System( /membrane )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( Cm )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( i_Stim )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Variable Variable( V )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( E_R )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_Stim )
	{
		Name	__none__;
		Expression	"piecewise( 20, and( geq( time.Value, 10 ), leq( time.Value, 10.5 ) ), 0 )";
		VariableReferenceList
			[ time   :/environment:time 0 ]
			[ i_Stim :/membrane:i_Stim  1 ];
	}
	
	Process ExpressionFluxProcess( V )
	{
		Name	__none__;
		Expression	"-( -i_Stim.Value + i_Na.Value + i_K.Value + i_L.Value ) / Cm.Value";
		VariableReferenceList
			[ V      :/membrane:V                     1 ]
			[ Cm     :/membrane:Cm                    0 ]
			[ i_Na   :/membrane/sodium_channel:i_Na   0 ]
			[ i_K    :/membrane/potassium_channel:i_K 0 ]
			[ i_L    :/membrane/leakage_current:i_L   0 ]
			[ i_Stim :/membrane:i_Stim                0 ];
	}
	
	
}

System System( /membrane/sodium_channel )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_Na )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( E_Na )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( i_Na )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( E_Na )
	{
		Name	__none__;
		Expression	"E_R.Value + 115";
		VariableReferenceList
			[ E_Na :/membrane/sodium_channel:E_Na 1 ]
			[ E_R  :/membrane:E_R                 0 ];
	}
	
	Process ExpressionAssignmentProcess( i_Na )
	{
		Name	__none__;
		Expression	"g_Na.Value * pow( m.Value, 3 ) * h.Value * ( V.Value - E_Na.Value )";
		VariableReferenceList
			[ i_Na :/membrane/sodium_channel:i_Na                    1 ]
			[ g_Na :/membrane/sodium_channel:g_Na                    0 ]
			[ E_Na :/membrane/sodium_channel:E_Na                    0 ]
			[ V    :/membrane:V                                      0 ]
			[ m    :/membrane/sodium_channel/sodium_channel_m_gate:m 0 ]
			[ h    :/membrane/sodium_channel/sodium_channel_h_gate:h 0 ];
	}
	
	
}

System System( /membrane/sodium_channel/sodium_channel_m_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_m )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( beta_m )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( m )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( alpha_m )
	{
		Name	__none__;
		Expression	"-0.1 * ( V.Value + 50 ) / ( exp( -( V.Value + 50 ) / 10 ) - 1 )";
		VariableReferenceList
			[ alpha_m :/membrane/sodium_channel/sodium_channel_m_gate:alpha_m 1 ]
			[ V       :/membrane:V                                            0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_m )
	{
		Name	__none__;
		Expression	"4 * exp( -( V.Value + 75 ) / 18 )";
		VariableReferenceList
			[ beta_m :/membrane/sodium_channel/sodium_channel_m_gate:beta_m 1 ]
			[ V      :/membrane:V                                           0 ];
	}
	
	Process ExpressionFluxProcess( m )
	{
		Name	__none__;
		Expression	"alpha_m.Value * ( 1 - m.Value ) - beta_m.Value * m.Value";
		VariableReferenceList
			[ m       :/membrane/sodium_channel/sodium_channel_m_gate:m       1 ]
			[ alpha_m :/membrane/sodium_channel/sodium_channel_m_gate:alpha_m 0 ]
			[ beta_m  :/membrane/sodium_channel/sodium_channel_m_gate:beta_m  0 ];
	}
	
	
}

System System( /membrane/sodium_channel/sodium_channel_h_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_h )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( beta_h )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( h )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( alpha_h )
	{
		Name	__none__;
		Expression	"0.07 * exp( -( V.Value + 75 ) / 20 )";
		VariableReferenceList
			[ alpha_h :/membrane/sodium_channel/sodium_channel_h_gate:alpha_h 1 ]
			[ V       :/membrane:V                                            0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_h )
	{
		Name	__none__;
		Expression	"1 / ( exp( -( V.Value + 45 ) / 10 ) + 1 )";
		VariableReferenceList
			[ beta_h :/membrane/sodium_channel/sodium_channel_h_gate:beta_h 1 ]
			[ V      :/membrane:V                                           0 ];
	}
	
	Process ExpressionFluxProcess( h )
	{
		Name	__none__;
		Expression	"alpha_h.Value * ( 1 - h.Value ) - beta_h.Value * h.Value";
		VariableReferenceList
			[ h       :/membrane/sodium_channel/sodium_channel_h_gate:h       1 ]
			[ alpha_h :/membrane/sodium_channel/sodium_channel_h_gate:alpha_h 0 ]
			[ beta_h  :/membrane/sodium_channel/sodium_channel_h_gate:beta_h  0 ];
	}
	
	
}

System System( /membrane/leakage_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_L )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( E_L )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( i_L )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( E_L )
	{
		Name	__none__;
		Expression	"E_R.Value + 10.613";
		VariableReferenceList
			[ E_L :/membrane/leakage_current:E_L 1 ]
			[ E_R :/membrane:E_R                 0 ];
	}
	
	Process ExpressionAssignmentProcess( i_L )
	{
		Name	__none__;
		Expression	"g_L.Value * ( V.Value - E_L.Value )";
		VariableReferenceList
			[ i_L :/membrane/leakage_current:i_L 1 ]
			[ g_L :/membrane/leakage_current:g_L 0 ]
			[ E_L :/membrane/leakage_current:E_L 0 ]
			[ V   :/membrane:V                   0 ];
	}
	
	
}

System System( /membrane/potassium_channel )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_K )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( E_K )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( i_K )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( E_K )
	{
		Name	__none__;
		Expression	"E_R.Value - 12";
		VariableReferenceList
			[ E_K :/membrane/potassium_channel:E_K 1 ]
			[ E_R :/membrane:E_R                   0 ];
	}
	
	Process ExpressionAssignmentProcess( i_K )
	{
		Name	__none__;
		Expression	"g_K.Value * pow( n.Value, 4 ) * ( V.Value - E_K.Value )";
		VariableReferenceList
			[ i_K :/membrane/potassium_channel:i_K                        1 ]
			[ g_K :/membrane/potassium_channel:g_K                        0 ]
			[ E_K :/membrane/potassium_channel:E_K                        0 ]
			[ V   :/membrane:V                                            0 ]
			[ n   :/membrane/potassium_channel/potassium_channel_n_gate:n 0 ];
	}
	
	
}

System System( /membrane/potassium_channel/potassium_channel_n_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_n )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( beta_n )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( n )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( alpha_n )
	{
		Name	__none__;
		Expression	"-0.01 * ( V.Value + 65 ) / ( exp( -( V.Value + 65 ) / 10 ) - 1 )";
		VariableReferenceList
			[ alpha_n :/membrane/potassium_channel/potassium_channel_n_gate:alpha_n 1 ]
			[ V       :/membrane:V                                                  0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_n )
	{
		Name	__none__;
		Expression	"0.125 * exp( V.Value + 75 / 80 )";
		VariableReferenceList
			[ beta_n :/membrane/potassium_channel/potassium_channel_n_gate:beta_n 1 ]
			[ V      :/membrane:V                                                 0 ];
	}
	
	Process ExpressionFluxProcess( n )
	{
		Name	__none__;
		Expression	"alpha_n.Value * ( 1 - n.Value ) - beta_n.Value * n.Value";
		VariableReferenceList
			[ n       :/membrane/potassium_channel/potassium_channel_n_gate:n       1 ]
			[ alpha_n :/membrane/potassium_channel/potassium_channel_n_gate:alpha_n 0 ]
			[ beta_n  :/membrane/potassium_channel/potassium_channel_n_gate:beta_n  0 ];
	}
	
	
}

