
# created by eml2em program
# from file: tentusscher_noble_noble_panfilov_2004_a.eml, date: Fri Mar 14 09:44:28 2014
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
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	
}

System System( /inward_rectifier_potassium_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_K1 )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( xK1_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( i_K1 )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( g_K1 )
	{
		Value	5.405;
		Name	__none__;
	}
	
	Variable Variable( beta_K1 )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( alpha_K1 )
	{
		Name	__none__;
		Expression	"0.1 / ( 1 + exp( 0.06 * ( V.Value - E_K.Value - 200 ) ) )";
		VariableReferenceList
			[ alpha_K1 :/inward_rectifier_potassium_current:alpha_K1 1 ]
			[ V        :/membrane:V                                  0 ]
			[ E_K      :/membrane/reversal_potentials:E_K            0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_K1 )
	{
		Name	__none__;
		Expression	"3 * exp( 0.0002 * ( V.Value - E_K.Value + 100 ) ) + exp( 0.1 * ( V.Value - E_K.Value - 10 ) ) / ( 1 + exp( -0.5 * ( V.Value - E_K.Value ) ) )";
		VariableReferenceList
			[ beta_K1 :/inward_rectifier_potassium_current:beta_K1 1 ]
			[ V       :/membrane:V                                 0 ]
			[ E_K     :/membrane/reversal_potentials:E_K           0 ];
	}
	
	Process ExpressionAssignmentProcess( xK1_inf )
	{
		Name	__none__;
		Expression	"alpha_K1.Value / ( alpha_K1.Value + beta_K1.Value )";
		VariableReferenceList
			[ beta_K1  :/inward_rectifier_potassium_current:beta_K1  0 ]
			[ alpha_K1 :/inward_rectifier_potassium_current:alpha_K1 0 ]
			[ xK1_inf  :/inward_rectifier_potassium_current:xK1_inf  1 ];
	}
	
	Process ExpressionAssignmentProcess( i_K1 )
	{
		Name	__none__;
		Expression	"g_K1.Value * xK1_inf.Value * sqrt( K_o.Value / 5.4 ) * ( V.Value - E_K.Value )";
		VariableReferenceList
			[ i_K1    :/inward_rectifier_potassium_current:i_K1    1 ]
			[ g_K1    :/inward_rectifier_potassium_current:g_K1    0 ]
			[ V       :/membrane:V                                 0 ]
			[ K_o     :/membrane/potassium_dynamics:K_o            0 ]
			[ E_K     :/membrane/reversal_potentials:E_K           0 ]
			[ xK1_inf :/inward_rectifier_potassium_current:xK1_inf 0 ];
	}
	
	
}

System System( /membrane )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( stim_period )
	{
		Value	1000;
		Name	__none__;
	}
	
	Variable Variable( T )
	{
		Value	310;
		Name	__none__;
	}
	
	Variable Variable( V )
	{
		Value	-86.2;
		Name	__none__;
	}
	
	Variable Variable( F )
	{
		Value	96485.3415;
		Name	__none__;
	}
	
	Variable Variable( stim_amplitude )
	{
		Value	52;
		Name	__none__;
	}
	
	Variable Variable( stim_duration )
	{
		Value	1;
		Name	__none__;
	}
	
	Variable Variable( R )
	{
		Value	8314.472;
		Name	__none__;
	}
	
	Variable Variable( stim_start )
	{
		Value	10;
		Name	__none__;
	}
	
	Variable Variable( V_c )
	{
		Value	0.016404;
		Name	__none__;
	}
	
	Variable Variable( i_Stim )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( Cm )
	{
		Value	0.185;
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
		Expression	"piecewise( -stim_amplitude.Value, and( geq( time.Value - floor( time.Value / stim_period.Value ) * stim_period.Value, stim_start.Value ), leq( time.Value - floor( time.Value / stim_period.Value ) * stim_period.Value, stim_start.Value + stim_duration.Value ) ), 0 )";
		VariableReferenceList
			[ stim_start     :/membrane:stim_start     0 ]
			[ stim_amplitude :/membrane:stim_amplitude 0 ]
			[ stim_period    :/membrane:stim_period    0 ]
			[ time           :/environment:time        0 ]
			[ stim_duration  :/membrane:stim_duration  0 ]
			[ i_Stim         :/membrane:i_Stim         1 ];
	}
	
	Process ExpressionFluxProcess( V )
	{
		Name	__none__;
		Expression	"-1 / 1 * ( i_K1.Value + i_to.Value + i_Kr.Value + i_Ks.Value + i_CaL.Value + i_NaK.Value + i_Na.Value + i_b_Na.Value + i_NaCa.Value + i_b_Ca.Value + i_p_K.Value + i_p_Ca.Value + i_Stim.Value )";
		VariableReferenceList
			[ i_K1   :/inward_rectifier_potassium_current:i_K1              0 ]
			[ i_p_Ca :/membrane/calcium_pump_current:i_p_Ca                 0 ]
			[ i_Na   :/membrane/fast_sodium_current:i_Na                    0 ]
			[ i_NaK  :/membrane/sodium_potassium_pump_current:i_NaK         0 ]
			[ i_to   :/membrane/transient_outward_current:i_to              0 ]
			[ i_NaCa :/membrane/sodium_calcium_exchanger_current:i_NaCa     0 ]
			[ i_p_K  :/membrane/potassium_pump_current:i_p_K                0 ]
			[ i_Ks   :/membrane/slow_time_dependent_potassium_current:i_Ks  0 ]
			[ i_Kr   :/membrane/rapid_time_dependent_potassium_current:i_Kr 0 ]
			[ i_CaL  :/membrane/L_type_Ca_current:i_CaL                     0 ]
			[ i_b_Na :/membrane/sodium_background_current:i_b_Na            0 ]
			[ V      :/membrane:V                                           1 ]
			[ i_b_Ca :/membrane/calcium_background_current:i_b_Ca           0 ]
			[ i_Stim :/membrane:i_Stim                                      0 ];
	}
	
	
}

System System( /membrane/fast_sodium_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( i_Na )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( g_Na )
	{
		Value	14.838;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_Na )
	{
		Name	__none__;
		Expression	"g_Na.Value * pow( m.Value, 3 ) * h.Value * j.Value * ( V.Value - E_Na.Value )";
		VariableReferenceList
			[ i_Na :/membrane/fast_sodium_current:i_Na                         1 ]
			[ h    :/membrane/fast_sodium_current/fast_sodium_current_h_gate:h 0 ]
			[ V    :/membrane:V                                                0 ]
			[ m    :/membrane/fast_sodium_current/fast_sodium_current_m_gate:m 0 ]
			[ j    :/membrane/fast_sodium_current/fast_sodium_current_j_gate:j 0 ]
			[ g_Na :/membrane/fast_sodium_current:g_Na                         0 ]
			[ E_Na :/membrane/reversal_potentials:E_Na                         0 ];
	}
	
	
}

System System( /membrane/fast_sodium_current/fast_sodium_current_m_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_m )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( m_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( m )
	{
		Value	0;
		Name	__none__;
	}
	
	Variable Variable( tau_m )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( beta_m )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( m_inf )
	{
		Name	__none__;
		Expression	"1 / pow( 1 + exp( -56.86 - V.Value / 9.03 ), 2 )";
		VariableReferenceList
			[ V     :/membrane:V                                                    0 ]
			[ m_inf :/membrane/fast_sodium_current/fast_sodium_current_m_gate:m_inf 1 ];
	}
	
	Process ExpressionAssignmentProcess( alpha_m )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( -60 - V.Value / 5 ) )";
		VariableReferenceList
			[ V       :/membrane:V                                                      0 ]
			[ alpha_m :/membrane/fast_sodium_current/fast_sodium_current_m_gate:alpha_m 1 ];
	}
	
	Process ExpressionAssignmentProcess( beta_m )
	{
		Name	__none__;
		Expression	"0.1 / ( 1 + exp( V.Value + 35 / 5 ) ) + 0.1 / ( 1 + exp( V.Value - 50 / 200 ) )";
		VariableReferenceList
			[ V      :/membrane:V                                                     0 ]
			[ beta_m :/membrane/fast_sodium_current/fast_sodium_current_m_gate:beta_m 1 ];
	}
	
	Process ExpressionAssignmentProcess( tau_m )
	{
		Name	__none__;
		Expression	"1 * alpha_m.Value * beta_m.Value";
		VariableReferenceList
			[ tau_m   :/membrane/fast_sodium_current/fast_sodium_current_m_gate:tau_m   1 ]
			[ alpha_m :/membrane/fast_sodium_current/fast_sodium_current_m_gate:alpha_m 0 ]
			[ beta_m  :/membrane/fast_sodium_current/fast_sodium_current_m_gate:beta_m  0 ];
	}
	
	Process ExpressionFluxProcess( m )
	{
		Name	__none__;
		Expression	"m_inf.Value - m.Value / tau_m.Value";
		VariableReferenceList
			[ tau_m :/membrane/fast_sodium_current/fast_sodium_current_m_gate:tau_m 0 ]
			[ m_inf :/membrane/fast_sodium_current/fast_sodium_current_m_gate:m_inf 0 ]
			[ m     :/membrane/fast_sodium_current/fast_sodium_current_m_gate:m     1 ];
	}
	
	
}

System System( /membrane/fast_sodium_current/fast_sodium_current_j_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( j )
	{
		Value	0.75;
		Name	__none__;
	}
	
	Variable Variable( alpha_j )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( tau_j )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( beta_j )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( j_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( j_inf )
	{
		Name	__none__;
		Expression	"1 / pow( 1 + exp( V.Value + 71.55 / 7.43 ), 2 )";
		VariableReferenceList
			[ V     :/membrane:V                                                    0 ]
			[ j_inf :/membrane/fast_sodium_current/fast_sodium_current_j_gate:j_inf 1 ];
	}
	
	Process ExpressionAssignmentProcess( alpha_j )
	{
		Name	__none__;
		Expression	"piecewise( ( -25428 * exp( 0.2444 * V.Value ) - 6.948    * exp( -0.04391 * V.Value ) ) * ( V.Value + 37.78 ) / 1 / ( 1 + exp( 0.311 * ( V.Value + 79.23 ) ) ), lt( V.Value, -40 ), 0 )";
		VariableReferenceList
			[ V       :/membrane:V                                                      0 ]
			[ alpha_j :/membrane/fast_sodium_current/fast_sodium_current_j_gate:alpha_j 1 ];
	}
	
	Process ExpressionAssignmentProcess( beta_j )
	{
		Name	__none__;
		Expression	"piecewise( 0.02424 * exp( -0.01052 * V.Value ) / ( 1 + exp( -0.1378 * ( V.Value + 40.14 ) ) ), lt( V.Value, -40 ), 0.6 * exp( 0.057 * V.Value ) / ( 1 + exp( -0.1 * ( V.Value + 32 ) ) ) )";
		VariableReferenceList
			[ V      :/membrane:V                                                     0 ]
			[ beta_j :/membrane/fast_sodium_current/fast_sodium_current_j_gate:beta_j 1 ];
	}
	
	Process ExpressionAssignmentProcess( tau_j )
	{
		Name	__none__;
		Expression	"1 / ( alpha_j.Value + beta_j.Value )";
		VariableReferenceList
			[ tau_j   :/membrane/fast_sodium_current/fast_sodium_current_j_gate:tau_j   1 ]
			[ alpha_j :/membrane/fast_sodium_current/fast_sodium_current_j_gate:alpha_j 0 ]
			[ beta_j  :/membrane/fast_sodium_current/fast_sodium_current_j_gate:beta_j  0 ];
	}
	
	Process ExpressionFluxProcess( j )
	{
		Name	__none__;
		Expression	"j_inf.Value - j.Value / tau_j.Value";
		VariableReferenceList
			[ tau_j :/membrane/fast_sodium_current/fast_sodium_current_j_gate:tau_j 0 ]
			[ j     :/membrane/fast_sodium_current/fast_sodium_current_j_gate:j     1 ]
			[ j_inf :/membrane/fast_sodium_current/fast_sodium_current_j_gate:j_inf 0 ];
	}
	
	
}

System System( /membrane/fast_sodium_current/fast_sodium_current_h_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_h )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( beta_h )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( tau_h )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( h_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( h )
	{
		Value	0.75;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( h_inf )
	{
		Name	__none__;
		Expression	"1 / pow( 1 + exp( V.Value + 71.55 / 7.43 ), 2 )";
		VariableReferenceList
			[ V     :/membrane:V                                                    0 ]
			[ h_inf :/membrane/fast_sodium_current/fast_sodium_current_h_gate:h_inf 1 ];
	}
	
	Process ExpressionAssignmentProcess( alpha_h )
	{
		Name	__none__;
		Expression	"piecewise( 0.057 * exp( -( V.Value + 80 ) / 6.8 ), lt( V.Value, -40 ), 0 )";
		VariableReferenceList
			[ V       :/membrane:V                                                      0 ]
			[ alpha_h :/membrane/fast_sodium_current/fast_sodium_current_h_gate:alpha_h 1 ];
	}
	
	Process ExpressionAssignmentProcess( beta_h )
	{
		Name	__none__;
		Expression	"piecewise( 2.7 * exp( 0.079 * V.Value ) + 310000 * exp( 0.3485 * V.Value ), lt( V.Value, -40 ), 0.77 / ( 0.13 * ( 1 + exp( V.Value + 10.66 / -11.1 ) ) ) )";
		VariableReferenceList
			[ V      :/membrane:V                                                     0 ]
			[ beta_h :/membrane/fast_sodium_current/fast_sodium_current_h_gate:beta_h 1 ];
	}
	
	Process ExpressionAssignmentProcess( tau_h )
	{
		Name	__none__;
		Expression	"1 / ( alpha_h.Value + beta_h.Value )";
		VariableReferenceList
			[ tau_h   :/membrane/fast_sodium_current/fast_sodium_current_h_gate:tau_h   1 ]
			[ alpha_h :/membrane/fast_sodium_current/fast_sodium_current_h_gate:alpha_h 0 ]
			[ beta_h  :/membrane/fast_sodium_current/fast_sodium_current_h_gate:beta_h  0 ];
	}
	
	Process ExpressionFluxProcess( h )
	{
		Name	__none__;
		Expression	"h_inf.Value - h.Value / tau_h.Value";
		VariableReferenceList
			[ tau_h :/membrane/fast_sodium_current/fast_sodium_current_h_gate:tau_h 0 ]
			[ h     :/membrane/fast_sodium_current/fast_sodium_current_h_gate:h     1 ]
			[ h_inf :/membrane/fast_sodium_current/fast_sodium_current_h_gate:h_inf 0 ];
	}
	
	
}

System System( /membrane/transient_outward_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_to )
	{
		Value	0.294;
		Name	__none__;
	}
	
	Variable Variable( i_to )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_to )
	{
		Name	__none__;
		Expression	"g_to.Value * r.Value * s.Value * ( V.Value - E_K.Value )";
		VariableReferenceList
			[ i_to :/membrane/transient_outward_current:i_to                               1 ]
			[ V    :/membrane:V                                                            0 ]
			[ s    :/membrane/transient_outward_current/transient_outward_current_s_gate:s 0 ]
			[ r    :/membrane/transient_outward_current/transient_outward_current_r_gate:r 0 ]
			[ g_to :/membrane/transient_outward_current:g_to                               0 ]
			[ E_K  :/membrane/reversal_potentials:E_K                                      0 ];
	}
	
	
}

System System( /membrane/transient_outward_current/transient_outward_current_s_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( s )
	{
		Value	1;
		Name	__none__;
	}
	
	Variable Variable( tau_s )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( s_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( s_inf )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( V.Value + 20 / 5 ) )";
		VariableReferenceList
			[ s_inf :/membrane/transient_outward_current/transient_outward_current_s_gate:s_inf 1 ]
			[ V     :/membrane:V                                                                0 ];
	}
	
	Process ExpressionAssignmentProcess( tau_s )
	{
		Name	__none__;
		Expression	"85 * exp( -pow( V.Value + 45, 2 ) / 320 ) + 5 / ( 1 + exp( V.Value - 20 / 5 ) ) + 3";
		VariableReferenceList
			[ tau_s :/membrane/transient_outward_current/transient_outward_current_s_gate:tau_s 1 ]
			[ V     :/membrane:V                                                                0 ];
	}
	
	Process ExpressionFluxProcess( s )
	{
		Name	__none__;
		Expression	"s_inf.Value - s.Value / tau_s.Value";
		VariableReferenceList
			[ s     :/membrane/transient_outward_current/transient_outward_current_s_gate:s     1 ]
			[ tau_s :/membrane/transient_outward_current/transient_outward_current_s_gate:tau_s 0 ]
			[ s_inf :/membrane/transient_outward_current/transient_outward_current_s_gate:s_inf 0 ];
	}
	
	
}

System System( /membrane/transient_outward_current/transient_outward_current_r_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( r_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( r )
	{
		Value	0;
		Name	__none__;
	}
	
	Variable Variable( tau_r )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( r_inf )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( 20 - V.Value / 6 ) )";
		VariableReferenceList
			[ r_inf :/membrane/transient_outward_current/transient_outward_current_r_gate:r_inf 1 ]
			[ V     :/membrane:V                                                                0 ];
	}
	
	Process ExpressionAssignmentProcess( tau_r )
	{
		Name	__none__;
		Expression	"9.5 * exp( -pow( V.Value + 40, 2 ) / 1800 ) + 0.8";
		VariableReferenceList
			[ tau_r :/membrane/transient_outward_current/transient_outward_current_r_gate:tau_r 1 ]
			[ V     :/membrane:V                                                                0 ];
	}
	
	Process ExpressionFluxProcess( r )
	{
		Name	__none__;
		Expression	"r_inf.Value - r.Value / tau_r.Value";
		VariableReferenceList
			[ tau_r :/membrane/transient_outward_current/transient_outward_current_r_gate:tau_r 0 ]
			[ r     :/membrane/transient_outward_current/transient_outward_current_r_gate:r     1 ]
			[ r_inf :/membrane/transient_outward_current/transient_outward_current_r_gate:r_inf 0 ];
	}
	
	
}

System System( /membrane/sodium_calcium_exchanger_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( K_NaCa )
	{
		Value	1000;
		Name	__none__;
	}
	
	Variable Variable( i_NaCa )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( gamma )
	{
		Value	0.35;
		Name	__none__;
	}
	
	Variable Variable( alpha )
	{
		Value	2.5;
		Name	__none__;
	}
	
	Variable Variable( K_sat )
	{
		Value	0.1;
		Name	__none__;
	}
	
	Variable Variable( Km_Nai )
	{
		Value	87.5;
		Name	__none__;
	}
	
	Variable Variable( Km_Ca )
	{
		Value	1.38;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_NaCa )
	{
		Name	__none__;
		Expression	"K_NaCa.Value * ( exp( gamma.Value * V.Value * F.Value / ( R.Value * T.Value ) ) * pow( Na_i.Value, 3 ) * Ca_o.Value - exp( ( gamma.Value - 1 ) * V.Value * F.Value / ( R.Value * T.Value ) ) * pow( Na_o.Value, 3 ) * Ca_i.Value * alpha.Value ) / ( ( pow( Km_Nai.Value, 3 ) + pow( Na_o.Value, 3 ) ) * ( Km_Ca.Value + Ca_o.Value ) * ( 1 + K_sat.Value * exp( ( gamma.Value - 1 ) * V.Value * F.Value / ( R.Value * T.Value ) ) ) )";
		VariableReferenceList
			[ Km_Nai :/membrane/sodium_calcium_exchanger_current:Km_Nai 0 ]
			[ i_NaCa :/membrane/sodium_calcium_exchanger_current:i_NaCa 1 ]
			[ F      :/membrane:F                                       0 ]
			[ V      :/membrane:V                                       0 ]
			[ T      :/membrane:T                                       0 ]
			[ Na_o   :/membrane/sodium_dynamics:Na_o                    0 ]
			[ Km_Ca  :/membrane/sodium_calcium_exchanger_current:Km_Ca  0 ]
			[ R      :/membrane:R                                       0 ]
			[ Ca_o   :/membrane/calcium_dynamics:Ca_o                   0 ]
			[ Na_i   :/membrane/sodium_dynamics:Na_i                    0 ]
			[ Ca_i   :/membrane/calcium_dynamics:Ca_i                   0 ]
			[ alpha  :/membrane/sodium_calcium_exchanger_current:alpha  0 ]
			[ K_NaCa :/membrane/sodium_calcium_exchanger_current:K_NaCa 0 ]
			[ gamma  :/membrane/sodium_calcium_exchanger_current:gamma  0 ]
			[ K_sat  :/membrane/sodium_calcium_exchanger_current:K_sat  0 ];
	}
	
	
}

System System( /membrane/calcium_background_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( i_b_Ca )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( g_bca )
	{
		Value	0.000592;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_b_Ca )
	{
		Name	__none__;
		Expression	"g_bca.Value * ( V.Value - E_Ca.Value )";
		VariableReferenceList
			[ g_bca  :/membrane/calcium_background_current:g_bca  0 ]
			[ V      :/membrane:V                                 0 ]
			[ i_b_Ca :/membrane/calcium_background_current:i_b_Ca 1 ]
			[ E_Ca   :/membrane/reversal_potentials:E_Ca          0 ];
	}
	
	
}

System System( /membrane/sodium_potassium_pump_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( K_mNa )
	{
		Value	40;
		Name	__none__;
	}
	
	Variable Variable( K_mk )
	{
		Value	1;
		Name	__none__;
	}
	
	Variable Variable( P_NaK )
	{
		Value	1.362;
		Name	__none__;
	}
	
	Variable Variable( i_NaK )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_NaK )
	{
		Name	__none__;
		Expression	"P_NaK.Value * K_o.Value / ( K_o.Value + K_mk.Value ) * Na_i.Value / ( Na_i.Value + K_mNa.Value ) / ( 1 + 0.1245 * exp( -0.1 * V.Value * F.Value / ( R.Value * T.Value ) ) + 0.0353 * exp( -V.Value * F.Value / ( R.Value * T.Value ) ) )";
		VariableReferenceList
			[ V     :/membrane:V                                   0 ]
			[ P_NaK :/membrane/sodium_potassium_pump_current:P_NaK 0 ]
			[ K_mNa :/membrane/sodium_potassium_pump_current:K_mNa 0 ]
			[ F     :/membrane:F                                   0 ]
			[ K_mk  :/membrane/sodium_potassium_pump_current:K_mk  0 ]
			[ R     :/membrane:R                                   0 ]
			[ T     :/membrane:T                                   0 ]
			[ K_o   :/membrane/potassium_dynamics:K_o              0 ]
			[ Na_i  :/membrane/sodium_dynamics:Na_i                0 ]
			[ i_NaK :/membrane/sodium_potassium_pump_current:i_NaK 1 ];
	}
	
	
}

System System( /membrane/potassium_pump_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( i_p_K )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( g_pK )
	{
		Value	0.0146;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_p_K )
	{
		Name	__none__;
		Expression	"g_pK.Value * ( V.Value - E_K.Value ) / ( 1 + exp( 25 - V.Value / 5.98 ) )";
		VariableReferenceList
			[ E_K   :/membrane/reversal_potentials:E_K      0 ]
			[ V     :/membrane:V                            0 ]
			[ g_pK  :/membrane/potassium_pump_current:g_pK  0 ]
			[ i_p_K :/membrane/potassium_pump_current:i_p_K 1 ];
	}
	
	
}

System System( /membrane/L_type_Ca_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( d )
	{
		Value	0;
		Name	__none__;
	}
	
	Variable Variable( i_CaL )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( g_CaL )
	{
		Value	0.000175;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_CaL )
	{
		Name	__none__;
		Expression	"g_CaL.Value * d.Value * f.Value * fCa.Value * 4 * V.Value * pow( F.Value, 2 ) / ( R.Value * T.Value ) * ( Ca_i.Value * exp( 2 * V.Value * F.Value / ( R.Value * T.Value ) ) - 0.341 * Ca_o.Value ) / ( exp( 2 * V.Value * F.Value / ( R.Value * T.Value ) ) - 1 )";
		VariableReferenceList
			[ V     :/membrane:V                                                0 ]
			[ f     :/membrane/L_type_Ca_current/L_type_Ca_current_f_gate:f     0 ]
			[ d     :/membrane/L_type_Ca_current:d                              0 ]
			[ F     :/membrane:F                                                0 ]
			[ g_CaL :/membrane/L_type_Ca_current:g_CaL                          0 ]
			[ i_CaL :/membrane/L_type_Ca_current:i_CaL                          1 ]
			[ fCa   :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:fCa 0 ]
			[ R     :/membrane:R                                                0 ]
			[ T     :/membrane:T                                                0 ]
			[ Ca_i  :/membrane/calcium_dynamics:Ca_i                            0 ]
			[ Ca_o  :/membrane/calcium_dynamics:Ca_o                            0 ];
	}
	
	
}

System System( /membrane/L_type_Ca_current/L_type_Ca_current_f_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( f_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( f )
	{
		Value	1;
		Name	__none__;
	}
	
	Variable Variable( tau_f )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( f_inf )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( V.Value + 20 / 7 ) )";
		VariableReferenceList
			[ V     :/membrane:V                                                0 ]
			[ f_inf :/membrane/L_type_Ca_current/L_type_Ca_current_f_gate:f_inf 1 ];
	}
	
	Process ExpressionAssignmentProcess( tau_f )
	{
		Name	__none__;
		Expression	"1125 * exp( -pow( V.Value + 27, 2 ) / 240 ) + 80 + 165 / ( 1 + exp( 25 - V.Value / 10 ) )";
		VariableReferenceList
			[ tau_f :/membrane/L_type_Ca_current/L_type_Ca_current_f_gate:tau_f 1 ]
			[ V     :/membrane:V                                                0 ];
	}
	
	Process ExpressionFluxProcess( f )
	{
		Name	__none__;
		Expression	"f_inf.Value - f.Value / tau_f.Value";
		VariableReferenceList
			[ tau_f :/membrane/L_type_Ca_current/L_type_Ca_current_f_gate:tau_f 0 ]
			[ f_inf :/membrane/L_type_Ca_current/L_type_Ca_current_f_gate:f_inf 0 ]
			[ f     :/membrane/L_type_Ca_current/L_type_Ca_current_f_gate:f     1 ];
	}
	
	
}

System System( /membrane/L_type_Ca_current/L_type_Ca_current_d_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( d_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( tau_d )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( beta_d )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( alpha_d )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( gamma_d )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( d_inf )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( -5 - V.Value / 7.5 ) )";
		VariableReferenceList
			[ V     :/membrane:V                                                0 ]
			[ d_inf :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:d_inf 1 ];
	}
	
	Process ExpressionAssignmentProcess( alpha_d )
	{
		Name	__none__;
		Expression	"1.4 / ( 1 + exp( -35 - V.Value / 13 ) ) + 0.25";
		VariableReferenceList
			[ alpha_d :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:alpha_d 1 ]
			[ V       :/membrane:V                                                  0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_d )
	{
		Name	__none__;
		Expression	"1.4 / ( 1 + exp( V.Value + 5 / 5 ) )";
		VariableReferenceList
			[ V      :/membrane:V                                                 0 ]
			[ beta_d :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:beta_d 1 ];
	}
	
	Process ExpressionAssignmentProcess( gamma_d )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( 50 - V.Value / 20 ) )";
		VariableReferenceList
			[ gamma_d :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:gamma_d 1 ]
			[ V       :/membrane:V                                                  0 ];
	}
	
	Process ExpressionAssignmentProcess( tau_d )
	{
		Name	__none__;
		Expression	"1 * alpha_d.Value * beta_d.Value + gamma_d.Value";
		VariableReferenceList
			[ alpha_d :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:alpha_d 0 ]
			[ gamma_d :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:gamma_d 0 ]
			[ tau_d   :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:tau_d   1 ]
			[ beta_d  :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:beta_d  0 ];
	}
	
	Process ExpressionFluxProcess( d )
	{
		Name	__none__;
		Expression	"d_inf.Value - d.Value / tau_d.Value";
		VariableReferenceList
			[ d     :/membrane/L_type_Ca_current:d                              1 ]
			[ tau_d :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:tau_d 0 ]
			[ d_inf :/membrane/L_type_Ca_current/L_type_Ca_current_d_gate:d_inf 0 ];
	}
	
	
}

System System( /membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( tau_fCa )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( gama_fCa )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( fCa )
	{
		Value	1;
		Name	__none__;
	}
	
	Variable Variable( fCa_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( d_fCa )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( beta_fCa )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( alpha_fCa )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( alpha_fCa )
	{
		Name	__none__;
		Expression	"1 / ( 1 + pow( Ca_i.Value / 0.000325, 8 ) )";
		VariableReferenceList
			[ alpha_fCa :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:alpha_fCa 1 ]
			[ Ca_i      :/membrane/calcium_dynamics:Ca_i                                  0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_fCa )
	{
		Name	__none__;
		Expression	"0.1 / ( 1 + exp( Ca_i.Value - 0.0005 / 0.0001 ) )";
		VariableReferenceList
			[ Ca_i     :/membrane/calcium_dynamics:Ca_i                                 0 ]
			[ beta_fCa :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:beta_fCa 1 ];
	}
	
	Process ExpressionAssignmentProcess( gama_fCa )
	{
		Name	__none__;
		Expression	"0.2 / ( 1 + exp( Ca_i.Value - 0.00075 / 0.0008 ) )";
		VariableReferenceList
			[ gama_fCa :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:gama_fCa 1 ]
			[ Ca_i     :/membrane/calcium_dynamics:Ca_i                                 0 ];
	}
	
	Process ExpressionAssignmentProcess( fCa_inf )
	{
		Name	__none__;
		Expression	"alpha_fCa.Value + beta_fCa.Value + gama_fCa.Value + 0.23 / 1.46";
		VariableReferenceList
			[ fCa_inf   :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:fCa_inf   1 ]
			[ alpha_fCa :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:alpha_fCa 0 ]
			[ gama_fCa  :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:gama_fCa  0 ]
			[ beta_fCa  :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:beta_fCa  0 ];
	}
	
	Process ExpressionAssignmentProcess( tau_fCa )
	{
		Name	__none__;
		Expression	2;
		VariableReferenceList
			[ tau_fCa :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:tau_fCa 1 ];
	}
	
	Process ExpressionAssignmentProcess( d_fCa )
	{
		Name	__none__;
		Expression	"fCa_inf.Value - fCa.Value / tau_fCa.Value";
		VariableReferenceList
			[ fCa_inf :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:fCa_inf 0 ]
			[ fCa     :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:fCa     0 ]
			[ tau_fCa :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:tau_fCa 0 ]
			[ d_fCa   :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:d_fCa   1 ];
	}
	
	Process ExpressionFluxProcess( fCa )
	{
		Name	__none__;
		Expression	"piecewise( 0, and( gt( fCa_inf.Value, fCa.Value ), gt( V.Value, -60 ) ), d_fCa.Value )";
		VariableReferenceList
			[ fCa_inf :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:fCa_inf 0 ]
			[ V       :/membrane:V                                                    0 ]
			[ fCa     :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:fCa     1 ]
			[ d_fCa   :/membrane/L_type_Ca_current/L_type_Ca_current_fCa_gate:d_fCa   0 ];
	}
	
	
}

System System( /membrane/sodium_background_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_bna )
	{
		Value	0.00029;
		Name	__none__;
	}
	
	Variable Variable( i_b_Na )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_b_Na )
	{
		Name	__none__;
		Expression	"g_bna.Value * ( V.Value - E_Na.Value )";
		VariableReferenceList
			[ g_bna  :/membrane/sodium_background_current:g_bna  0 ]
			[ i_b_Na :/membrane/sodium_background_current:i_b_Na 1 ]
			[ V      :/membrane:V                                0 ]
			[ E_Na   :/membrane/reversal_potentials:E_Na         0 ];
	}
	
	
}

System System( /membrane/slow_time_dependent_potassium_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( i_Ks )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( g_Ks )
	{
		Value	0.062;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_Ks )
	{
		Name	__none__;
		Expression	"g_Ks.Value * pow( Xs.Value, 2 ) * ( V.Value - E_Ks.Value )";
		VariableReferenceList
			[ i_Ks :/membrane/slow_time_dependent_potassium_current:i_Ks                                             1 ]
			[ E_Ks :/membrane/reversal_potentials:E_Ks                                                               0 ]
			[ g_Ks :/membrane/slow_time_dependent_potassium_current:g_Ks                                             0 ]
			[ V    :/membrane:V                                                                                      0 ]
			[ Xs   :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:Xs 0 ];
	}
	
	
}

System System( /membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_xs )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( beta_xs )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( xs_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( tau_xs )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( Xs )
	{
		Value	0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( xs_inf )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( -5 - V.Value / 14 ) )";
		VariableReferenceList
			[ V      :/membrane:V                                                                                          0 ]
			[ xs_inf :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:xs_inf 1 ];
	}
	
	Process ExpressionAssignmentProcess( alpha_xs )
	{
		Name	__none__;
		Expression	"1100 / sqrt( 1 + exp( -10 - V.Value / 6 ) )";
		VariableReferenceList
			[ V        :/membrane:V                                                                                            0 ]
			[ alpha_xs :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:alpha_xs 1 ];
	}
	
	Process ExpressionAssignmentProcess( beta_xs )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( V.Value - 60 / 20 ) )";
		VariableReferenceList
			[ V       :/membrane:V                                                                                           0 ]
			[ beta_xs :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:beta_xs 1 ];
	}
	
	Process ExpressionAssignmentProcess( tau_xs )
	{
		Name	__none__;
		Expression	"1 * alpha_xs.Value * beta_xs.Value";
		VariableReferenceList
			[ tau_xs   :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:tau_xs   1 ]
			[ alpha_xs :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:alpha_xs 0 ]
			[ beta_xs  :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:beta_xs  0 ];
	}
	
	Process ExpressionFluxProcess( Xs )
	{
		Name	__none__;
		Expression	"xs_inf.Value - Xs.Value / tau_xs.Value";
		VariableReferenceList
			[ tau_xs :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:tau_xs 0 ]
			[ xs_inf :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:xs_inf 0 ]
			[ Xs     :/membrane/slow_time_dependent_potassium_current/slow_time_dependent_potassium_current_Xs_gate:Xs     1 ];
	}
	
	
}

System System( /membrane/reversal_potentials )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( E_K )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( P_kna )
	{
		Value	0.03;
		Name	__none__;
	}
	
	Variable Variable( E_Ks )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( E_Na )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( E_Ca )
	{
		Value	NaN;
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
		Expression	"R.Value * T.Value / F.Value * ln( Na_o.Value / Na_i.Value )";
		VariableReferenceList
			[ F    :/membrane:F                        0 ]
			[ Na_o :/membrane/sodium_dynamics:Na_o     0 ]
			[ R    :/membrane:R                        0 ]
			[ T    :/membrane:T                        0 ]
			[ Na_i :/membrane/sodium_dynamics:Na_i     0 ]
			[ E_Na :/membrane/reversal_potentials:E_Na 1 ];
	}
	
	Process ExpressionAssignmentProcess( E_K )
	{
		Name	__none__;
		Expression	"R.Value * T.Value / F.Value * ln( K_o.Value / K_i.Value )";
		VariableReferenceList
			[ K_i :/membrane/potassium_dynamics:K_i  0 ]
			[ F   :/membrane:F                       0 ]
			[ R   :/membrane:R                       0 ]
			[ T   :/membrane:T                       0 ]
			[ K_o :/membrane/potassium_dynamics:K_o  0 ]
			[ E_K :/membrane/reversal_potentials:E_K 1 ];
	}
	
	Process ExpressionAssignmentProcess( E_Ks )
	{
		Name	__none__;
		Expression	"R.Value * T.Value / F.Value * ln( K_o.Value + P_kna.Value * Na_o.Value / ( K_i.Value + P_kna.Value * Na_i.Value ) )";
		VariableReferenceList
			[ K_i   :/membrane/potassium_dynamics:K_i    0 ]
			[ E_Ks  :/membrane/reversal_potentials:E_Ks  1 ]
			[ F     :/membrane:F                         0 ]
			[ P_kna :/membrane/reversal_potentials:P_kna 0 ]
			[ Na_o  :/membrane/sodium_dynamics:Na_o      0 ]
			[ R     :/membrane:R                         0 ]
			[ T     :/membrane:T                         0 ]
			[ K_o   :/membrane/potassium_dynamics:K_o    0 ]
			[ Na_i  :/membrane/sodium_dynamics:Na_i      0 ];
	}
	
	Process ExpressionAssignmentProcess( E_Ca )
	{
		Name	__none__;
		Expression	"0.5 * R.Value * T.Value / F.Value * ln( Ca_o.Value / Ca_i.Value )";
		VariableReferenceList
			[ F    :/membrane:F                        0 ]
			[ Ca_i :/membrane/calcium_dynamics:Ca_i    0 ]
			[ R    :/membrane:R                        0 ]
			[ T    :/membrane:T                        0 ]
			[ E_Ca :/membrane/reversal_potentials:E_Ca 1 ]
			[ Ca_o :/membrane/calcium_dynamics:Ca_o    0 ];
	}
	
	
}

System System( /membrane/rapid_time_dependent_potassium_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( i_Kr )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( g_Kr )
	{
		Value	0.096;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_Kr )
	{
		Name	__none__;
		Expression	"g_Kr.Value * sqrt( K_o.Value / 5.4 ) * Xr1.Value * Xr2.Value * ( V.Value - E_K.Value )";
		VariableReferenceList
			[ i_Kr :/membrane/rapid_time_dependent_potassium_current:i_Kr                                                1 ]
			[ g_Kr :/membrane/rapid_time_dependent_potassium_current:g_Kr                                                0 ]
			[ K_o  :/membrane/potassium_dynamics:K_o                                                                     0 ]
			[ V    :/membrane:V                                                                                          0 ]
			[ E_K  :/membrane/reversal_potentials:E_K                                                                    0 ]
			[ Xr1  :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:Xr1 0 ]
			[ Xr2  :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:Xr2 0 ];
	}
	
	
}

System System( /membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( Xr2 )
	{
		Value	1;
		Name	__none__;
	}
	
	Variable Variable( tau_xr2 )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( alpha_xr2 )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( xr2_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( beta_xr2 )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( xr2_inf )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( V.Value + 88 / 24 ) )";
		VariableReferenceList
			[ xr2_inf :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:xr2_inf 1 ]
			[ V       :/membrane:V                                                                                              0 ];
	}
	
	Process ExpressionAssignmentProcess( alpha_xr2 )
	{
		Name	__none__;
		Expression	"3 / ( 1 + exp( -60 - V.Value / 20 ) )";
		VariableReferenceList
			[ alpha_xr2 :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:alpha_xr2 1 ]
			[ V         :/membrane:V                                                                                                0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_xr2 )
	{
		Name	__none__;
		Expression	"1.12 / ( 1 + exp( V.Value - 60 / 20 ) )";
		VariableReferenceList
			[ beta_xr2 :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:beta_xr2 1 ]
			[ V        :/membrane:V                                                                                               0 ];
	}
	
	Process ExpressionAssignmentProcess( tau_xr2 )
	{
		Name	__none__;
		Expression	"1 * alpha_xr2.Value * beta_xr2.Value";
		VariableReferenceList
			[ beta_xr2  :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:beta_xr2  0 ]
			[ alpha_xr2 :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:alpha_xr2 0 ]
			[ tau_xr2   :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:tau_xr2   1 ];
	}
	
	Process ExpressionFluxProcess( Xr2 )
	{
		Name	__none__;
		Expression	"xr2_inf.Value - Xr2.Value / tau_xr2.Value";
		VariableReferenceList
			[ xr2_inf :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:xr2_inf 0 ]
			[ tau_xr2 :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:tau_xr2 0 ]
			[ Xr2     :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr2_gate:Xr2     1 ];
	}
	
	
}

System System( /membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( tau_xr1 )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( Xr1 )
	{
		Value	0;
		Name	__none__;
	}
	
	Variable Variable( beta_xr1 )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( alpha_xr1 )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( xr1_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( xr1_inf )
	{
		Name	__none__;
		Expression	"1 / ( 1 + exp( -26 - V.Value / 7 ) )";
		VariableReferenceList
			[ xr1_inf :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:xr1_inf 1 ]
			[ V       :/membrane:V                                                                                              0 ];
	}
	
	Process ExpressionAssignmentProcess( alpha_xr1 )
	{
		Name	__none__;
		Expression	"450 / ( 1 + exp( -45 - V.Value / 10 ) )";
		VariableReferenceList
			[ V         :/membrane:V                                                                                                0 ]
			[ alpha_xr1 :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:alpha_xr1 1 ];
	}
	
	Process ExpressionAssignmentProcess( beta_xr1 )
	{
		Name	__none__;
		Expression	"6 / ( 1 + exp( V.Value + 30 / 11.5 ) )";
		VariableReferenceList
			[ beta_xr1 :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:beta_xr1 1 ]
			[ V        :/membrane:V                                                                                               0 ];
	}
	
	Process ExpressionAssignmentProcess( tau_xr1 )
	{
		Name	__none__;
		Expression	"1 * alpha_xr1.Value * beta_xr1.Value";
		VariableReferenceList
			[ beta_xr1  :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:beta_xr1  0 ]
			[ alpha_xr1 :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:alpha_xr1 0 ]
			[ tau_xr1   :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:tau_xr1   1 ];
	}
	
	Process ExpressionFluxProcess( Xr1 )
	{
		Name	__none__;
		Expression	"xr1_inf.Value - Xr1.Value / tau_xr1.Value";
		VariableReferenceList
			[ xr1_inf :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:xr1_inf 0 ]
			[ Xr1     :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:Xr1     1 ]
			[ tau_xr1 :/membrane/rapid_time_dependent_potassium_current/rapid_time_dependent_potassium_current_Xr1_gate:tau_xr1 0 ];
	}
	
	
}

System System( /membrane/sodium_dynamics )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( Na_o )
	{
		Value	140;
		Name	__none__;
	}
	
	Variable Variable( Na_i )
	{
		Value	11.6;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionFluxProcess( Na_i )
	{
		Name	__none__;
		Expression	"-1 * ( i_Na.Value + i_b_Na.Value + 3 * i_NaK.Value + 3 * i_NaCa.Value ) * Cm.Value / ( 1 * V_c.Value * F.Value )";
		VariableReferenceList
			[ i_Na   :/membrane/fast_sodium_current:i_Na                0 ]
			[ i_NaCa :/membrane/sodium_calcium_exchanger_current:i_NaCa 0 ]
			[ Cm     :/membrane:Cm                                      0 ]
			[ F      :/membrane:F                                       0 ]
			[ V_c    :/membrane:V_c                                     0 ]
			[ i_b_Na :/membrane/sodium_background_current:i_b_Na        0 ]
			[ i_NaK  :/membrane/sodium_potassium_pump_current:i_NaK     0 ]
			[ Na_i   :/membrane/sodium_dynamics:Na_i                    1 ];
	}
	
	
}

System System( /membrane/calcium_pump_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_pCa )
	{
		Value	0.825;
		Name	__none__;
	}
	
	Variable Variable( K_pCa )
	{
		Value	0.0005;
		Name	__none__;
	}
	
	Variable Variable( i_p_Ca )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_p_Ca )
	{
		Name	__none__;
		Expression	"g_pCa.Value * Ca_i.Value / ( Ca_i.Value + K_pCa.Value )";
		VariableReferenceList
			[ Ca_i   :/membrane/calcium_dynamics:Ca_i       0 ]
			[ i_p_Ca :/membrane/calcium_pump_current:i_p_Ca 1 ]
			[ K_pCa  :/membrane/calcium_pump_current:K_pCa  0 ]
			[ g_pCa  :/membrane/calcium_pump_current:g_pCa  0 ];
	}
	
	
}

System System( /membrane/calcium_dynamics )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( c_rel )
	{
		Value	0.008232;
		Name	__none__;
	}
	
	Variable Variable( K_buf_sr )
	{
		Value	0.3;
		Name	__none__;
	}
	
	Variable Variable( Ca_i_bufc )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( Ca_SR )
	{
		Value	0.2;
		Name	__none__;
	}
	
	Variable Variable( g )
	{
		Value	1;
		Name	__none__;
	}
	
	Variable Variable( V_sr )
	{
		Value	0.001094;
		Name	__none__;
	}
	
	Variable Variable( a_rel )
	{
		Value	0.016464;
		Name	__none__;
	}
	
	Variable Variable( tau_g )
	{
		Value	2;
		Name	__none__;
	}
	
	Variable Variable( d_g )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( g_inf )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( Vmax_up )
	{
		Value	0.000425;
		Name	__none__;
	}
	
	Variable Variable( i_leak )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( i_up )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( Buf_sr )
	{
		Value	10;
		Name	__none__;
	}
	
	Variable Variable( Ca_i )
	{
		Value	0.0002;
		Name	__none__;
	}
	
	Variable Variable( i_rel )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( K_up )
	{
		Value	0.00025;
		Name	__none__;
	}
	
	Variable Variable( Ca_sr_bufsr )
	{
		Value	NaN;
		Name	__none__;
	}
	
	Variable Variable( Buf_c )
	{
		Value	0.15;
		Name	__none__;
	}
	
	Variable Variable( K_buf_c )
	{
		Value	0.001;
		Name	__none__;
	}
	
	Variable Variable( b_rel )
	{
		Value	0.25;
		Name	__none__;
	}
	
	Variable Variable( V_leak )
	{
		Value	8e-5;
		Name	__none__;
	}
	
	Variable Variable( Ca_o )
	{
		Value	2;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_rel )
	{
		Name	__none__;
		Expression	"( a_rel.Value * pow( Ca_SR.Value, 2 ) / ( pow( b_rel.Value, 2 ) + pow( Ca_SR.Value, 2 ) ) + c_rel.Value ) * d.Value * g.Value";
		VariableReferenceList
			[ a_rel :/membrane/calcium_dynamics:a_rel 0 ]
			[ i_rel :/membrane/calcium_dynamics:i_rel 1 ]
			[ c_rel :/membrane/calcium_dynamics:c_rel 0 ]
			[ Ca_SR :/membrane/calcium_dynamics:Ca_SR 0 ]
			[ b_rel :/membrane/calcium_dynamics:b_rel 0 ]
			[ d     :/membrane/L_type_Ca_current:d    0 ]
			[ g     :/membrane/calcium_dynamics:g     0 ];
	}
	
	Process ExpressionAssignmentProcess( i_up )
	{
		Name	__none__;
		Expression	"Vmax_up.Value / ( 1 + pow( K_up.Value, 2 ) / pow( Ca_i.Value, 2 ) )";
		VariableReferenceList
			[ Ca_i    :/membrane/calcium_dynamics:Ca_i    0 ]
			[ K_up    :/membrane/calcium_dynamics:K_up    0 ]
			[ Vmax_up :/membrane/calcium_dynamics:Vmax_up 0 ]
			[ i_up    :/membrane/calcium_dynamics:i_up    1 ];
	}
	
	Process ExpressionAssignmentProcess( i_leak )
	{
		Name	__none__;
		Expression	"V_leak.Value * ( Ca_SR.Value - Ca_i.Value )";
		VariableReferenceList
			[ Ca_i   :/membrane/calcium_dynamics:Ca_i   0 ]
			[ Ca_SR  :/membrane/calcium_dynamics:Ca_SR  0 ]
			[ V_leak :/membrane/calcium_dynamics:V_leak 0 ]
			[ i_leak :/membrane/calcium_dynamics:i_leak 1 ];
	}
	
	Process ExpressionAssignmentProcess( g_inf )
	{
		Name	__none__;
		Expression	"piecewise( 1 / ( 1 + pow( Ca_i.Value / 0.00035, 6 ) ), lt( Ca_i.Value, 0.00035 ), 1 / ( 1 + pow( Ca_i.Value / 0.00035, 16 ) ) )";
		VariableReferenceList
			[ Ca_i  :/membrane/calcium_dynamics:Ca_i  0 ]
			[ g_inf :/membrane/calcium_dynamics:g_inf 1 ];
	}
	
	Process ExpressionAssignmentProcess( d_g )
	{
		Name	__none__;
		Expression	"g_inf.Value - g.Value / tau_g.Value";
		VariableReferenceList
			[ tau_g :/membrane/calcium_dynamics:tau_g 0 ]
			[ g_inf :/membrane/calcium_dynamics:g_inf 0 ]
			[ g     :/membrane/calcium_dynamics:g     0 ]
			[ d_g   :/membrane/calcium_dynamics:d_g   1 ];
	}
	
	Process ExpressionFluxProcess( g )
	{
		Name	__none__;
		Expression	"piecewise( 0, and( gt( g_inf.Value, g.Value ), gt( V.Value, -60 ) ), d_g.Value )";
		VariableReferenceList
			[ V     :/membrane:V                      0 ]
			[ g_inf :/membrane/calcium_dynamics:g_inf 0 ]
			[ g     :/membrane/calcium_dynamics:g     1 ]
			[ d_g   :/membrane/calcium_dynamics:d_g   0 ];
	}
	
	Process ExpressionAssignmentProcess( Ca_i_bufc )
	{
		Name	__none__;
		Expression	"1 / ( 1 + Buf_c.Value * K_buf_c.Value / pow( Ca_i.Value + K_buf_c.Value, 2 ) )";
		VariableReferenceList
			[ Buf_c     :/membrane/calcium_dynamics:Buf_c     0 ]
			[ Ca_i      :/membrane/calcium_dynamics:Ca_i      0 ]
			[ Ca_i_bufc :/membrane/calcium_dynamics:Ca_i_bufc 1 ]
			[ K_buf_c   :/membrane/calcium_dynamics:K_buf_c   0 ];
	}
	
	Process ExpressionAssignmentProcess( Ca_sr_bufsr )
	{
		Name	__none__;
		Expression	"1 / ( 1 + Buf_sr.Value * K_buf_sr.Value / pow( Ca_SR.Value + K_buf_sr.Value, 2 ) )";
		VariableReferenceList
			[ Buf_sr      :/membrane/calcium_dynamics:Buf_sr      0 ]
			[ Ca_SR       :/membrane/calcium_dynamics:Ca_SR       0 ]
			[ Ca_sr_bufsr :/membrane/calcium_dynamics:Ca_sr_bufsr 1 ]
			[ K_buf_sr    :/membrane/calcium_dynamics:K_buf_sr    0 ];
	}
	
	Process ExpressionFluxProcess( Ca_i )
	{
		Name	__none__;
		Expression	"Ca_i_bufc.Value * ( i_leak.Value - i_up.Value + i_rel.Value - 1 * ( i_CaL.Value + i_b_Ca.Value + i_p_Ca.Value - 2 * i_NaCa.Value ) / ( 2 * 1 * V_c.Value * F.Value ) * Cm.Value )";
		VariableReferenceList
			[ i_p_Ca    :/membrane/calcium_pump_current:i_p_Ca             0 ]
			[ Cm        :/membrane:Cm                                      0 ]
			[ i_rel     :/membrane/calcium_dynamics:i_rel                  0 ]
			[ Ca_i      :/membrane/calcium_dynamics:Ca_i                   1 ]
			[ Ca_i_bufc :/membrane/calcium_dynamics:Ca_i_bufc              0 ]
			[ F         :/membrane:F                                       0 ]
			[ V_c       :/membrane:V_c                                     0 ]
			[ i_leak    :/membrane/calcium_dynamics:i_leak                 0 ]
			[ i_NaCa    :/membrane/sodium_calcium_exchanger_current:i_NaCa 0 ]
			[ i_CaL     :/membrane/L_type_Ca_current:i_CaL                 0 ]
			[ i_b_Ca    :/membrane/calcium_background_current:i_b_Ca       0 ]
			[ i_up      :/membrane/calcium_dynamics:i_up                   0 ];
	}
	
	Process ExpressionFluxProcess( Ca_SR )
	{
		Name	__none__;
		Expression	"Ca_sr_bufsr.Value * V_c.Value / V_sr.Value * ( i_up.Value - i_rel.Value + i_leak.Value )";
		VariableReferenceList
			[ i_rel       :/membrane/calcium_dynamics:i_rel       0 ]
			[ V_sr        :/membrane/calcium_dynamics:V_sr        0 ]
			[ Ca_SR       :/membrane/calcium_dynamics:Ca_SR       1 ]
			[ V_c         :/membrane:V_c                          0 ]
			[ Ca_sr_bufsr :/membrane/calcium_dynamics:Ca_sr_bufsr 0 ]
			[ i_leak      :/membrane/calcium_dynamics:i_leak      0 ]
			[ i_up        :/membrane/calcium_dynamics:i_up        0 ];
	}
	
	
}

System System( /membrane/potassium_dynamics )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( K_o )
	{
		Value	5.4;
		Name	__none__;
	}
	
	Variable Variable( K_i )
	{
		Value	138.3;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionFluxProcess( K_i )
	{
		Name	__none__;
		Expression	"-1 * ( i_K1.Value + i_to.Value + i_Kr.Value + i_Ks.Value + i_p_K.Value + i_Stim.Value - 2 * i_NaK.Value ) * Cm.Value / ( 1 * V_c.Value * F.Value )";
		VariableReferenceList
			[ i_K1   :/inward_rectifier_potassium_current:i_K1              0 ]
			[ i_Ks   :/membrane/slow_time_dependent_potassium_current:i_Ks  0 ]
			[ i_to   :/membrane/transient_outward_current:i_to              0 ]
			[ Cm     :/membrane:Cm                                          0 ]
			[ F      :/membrane:F                                           0 ]
			[ i_p_K  :/membrane/potassium_pump_current:i_p_K                0 ]
			[ K_i    :/membrane/potassium_dynamics:K_i                      1 ]
			[ i_Kr   :/membrane/rapid_time_dependent_potassium_current:i_Kr 0 ]
			[ V_c    :/membrane:V_c                                         0 ]
			[ i_NaK  :/membrane/sodium_potassium_pump_current:i_NaK         0 ]
			[ i_Stim :/membrane:i_Stim                                      0 ];
	}
	
	
}

