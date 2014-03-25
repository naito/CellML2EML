
# created by eml2em program
# from file: luo_rudy_1994.cellml.eml, date: Sat Mar 22 17:23:29 2014
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

System System( /fast_sodium_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_Na )
	{
		Value	0.16;
		Name	__none__;
	}
	
	Variable Variable( i_Na )
	{
		Value	-0.0;
		Name	__none__;
	}
	
	Variable Variable( E_Na )
	{
		Value	70.2375659228;
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
		Expression	"g_Na.Value * pow( m.Value, 3.0 ) * h.Value * j.Value * ( V.Value - E_Na.Value )";
		VariableReferenceList
			[ i_Na :/fast_sodium_current:i_Na     1 ]
			[ E_Na :/fast_sodium_current:E_Na     0 ]
			[ g_Na :/fast_sodium_current:g_Na     0 ]
			[ V    :/membrane:V                   0 ]
			[ m    :/fast_sodium_current_m_gate:m 0 ]
			[ h    :/fast_sodium_current_h_gate:h 0 ]
			[ j    :/fast_sodium_current_j_gate:j 0 ];
	}
	
	Process ExpressionAssignmentProcess( E_Na )
	{
		Name	__none__;
		Expression	"R.Value * T.Value / F.Value * log( Nao.Value / Nai.Value )";
		VariableReferenceList
			[ E_Na :/fast_sodium_current:E_Na 1 ]
			[ R    :/membrane:R               0 ]
			[ F    :/membrane:F               0 ]
			[ T    :/membrane:T               0 ]
			[ Nai  :/ionic_concentrations:Nai 0 ]
			[ Nao  :/ionic_concentrations:Nao 0 ];
	}
	
	
}

System System( /calcium_background_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_Cab )
	{
		Value	3.016e-5;
		Name	__none__;
	}
	
	Variable Variable( E_CaN )
	{
		Value	127.960609974;
		Name	__none__;
	}
	
	Variable Variable( i_Ca_b )
	{
		Value	-0.00641155183682;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( E_CaN )
	{
		Name	__none__;
		Expression	"R.Value * T.Value / ( 2.0 * F.Value ) * log( Cao.Value / Cai.Value )";
		VariableReferenceList
			[ E_CaN :/calcium_background_current:E_CaN 1 ]
			[ R     :/membrane:R                       0 ]
			[ T     :/membrane:T                       0 ]
			[ F     :/membrane:F                       0 ]
			[ Cai   :/ionic_concentrations:Cai         0 ]
			[ Cao   :/ionic_concentrations:Cao         0 ];
	}
	
	Process ExpressionAssignmentProcess( i_Ca_b )
	{
		Name	__none__;
		Expression	"g_Cab.Value * ( V.Value - E_CaN.Value )";
		VariableReferenceList
			[ i_Ca_b :/calcium_background_current:i_Ca_b 1 ]
			[ g_Cab  :/calcium_background_current:g_Cab  0 ]
			[ E_CaN  :/calcium_background_current:E_CaN  0 ]
			[ V      :/membrane:V                        0 ];
	}
	
	
}

System System( /sodium_potassium_pump )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( I_NaK )
	{
		Value	1.5e-2;
		Name	__none__;
	}
	
	Variable Variable( f_NaK )
	{
		Value	0.487981028701;
		Name	__none__;
	}
	
	Variable Variable( K_mNai )
	{
		Value	10.0;
		Name	__none__;
	}
	
	Variable Variable( K_mKo )
	{
		Value	1.5;
		Name	__none__;
	}
	
	Variable Variable( sigma )
	{
		Value	1.00091030495;
		Name	__none__;
	}
	
	Variable Variable( i_NaK )
	{
		Value	0.00286423647281;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( f_NaK )
	{
		Name	__none__;
		Expression	"1.0 / ( 1.0 + 0.1245 * exp( -0.1 * V.Value * F.Value / ( R.Value * T.Value ) ) + 0.0365 * sigma.Value * exp( -( V.Value * F.Value / ( R.Value * T.Value ) ) ) )";
		VariableReferenceList
			[ f_NaK :/sodium_potassium_pump:f_NaK 1 ]
			[ sigma :/sodium_potassium_pump:sigma 0 ]
			[ V     :/membrane:V                  0 ]
			[ R     :/membrane:R                  0 ]
			[ T     :/membrane:T                  0 ]
			[ F     :/membrane:F                  0 ];
	}
	
	Process ExpressionAssignmentProcess( sigma )
	{
		Name	__none__;
		Expression	"1.0 / 7.0 * ( exp( Nao.Value / 67.3 ) - 1.0 )";
		VariableReferenceList
			[ sigma :/sodium_potassium_pump:sigma 1 ]
			[ Nao   :/ionic_concentrations:Nao    0 ];
	}
	
	Process ExpressionAssignmentProcess( i_NaK )
	{
		Name	__none__;
		Expression	"I_NaK.Value * f_NaK.Value * 1.0 / ( 1.0 + pow( K_mNai.Value / Nai.Value, 1.5 ) ) * Ko.Value / ( Ko.Value + K_mKo.Value )";
		VariableReferenceList
			[ i_NaK  :/sodium_potassium_pump:i_NaK  1 ]
			[ I_NaK  :/sodium_potassium_pump:I_NaK  0 ]
			[ f_NaK  :/sodium_potassium_pump:f_NaK  0 ]
			[ K_mNai :/sodium_potassium_pump:K_mNai 0 ]
			[ K_mKo  :/sodium_potassium_pump:K_mKo  0 ]
			[ Nai    :/ionic_concentrations:Nai     0 ]
			[ Ko     :/ionic_concentrations:Ko      0 ];
	}
	
	
}

System System( /calcium_fluxes_in_the_SR )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( G_rel )
	{
		Value	-0.0;
		Name	__none__;
	}
	
	Variable Variable( G_rel_peak )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( G_rel_max )
	{
		Value	60.0;
		Name	__none__;
	}
	
	Variable Variable( tau_on )
	{
		Value	2.0;
		Name	__none__;
	}
	
	Variable Variable( tau_off )
	{
		Value	2.0;
		Name	__none__;
	}
	
	Variable Variable( t_CICR )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( tau_tr )
	{
		Value	180.0;
		Name	__none__;
	}
	
	Variable Variable( K_mrel )
	{
		Value	0.8e-3;
		Name	__none__;
	}
	
	Variable Variable( K_mup )
	{
		Value	0.92e-3;
		Name	__none__;
	}
	
	Variable Variable( K_leak )
	{
		Value	0.000333333333333;
		Name	__none__;
	}
	
	Variable Variable( I_up )
	{
		Value	0.005;
		Name	__none__;
	}
	
	Variable Variable( Ca_NSR_max )
	{
		Value	15.0;
		Name	__none__;
	}
	
	Variable Variable( delta_Ca_i2 )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( delta_Ca_ith )
	{
		Value	0.18e-3;
		Name	__none__;
	}
	
	Variable Variable( i_rel )
	{
		Value	-0.0;
		Name	__none__;
	}
	
	Variable Variable( i_tr )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( i_leak )
	{
		Value	0.0006;
		Name	__none__;
	}
	
	Variable Variable( i_up )
	{
		Value	0.000576923076923;
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
		Expression	"G_rel.Value * ( Ca_JSR.Value - Cai.Value )";
		VariableReferenceList
			[ i_rel  :/calcium_fluxes_in_the_SR:i_rel 1 ]
			[ G_rel  :/calcium_fluxes_in_the_SR:G_rel 0 ]
			[ Cai    :/ionic_concentrations:Cai       0 ]
			[ Ca_JSR :/ionic_concentrations:Ca_JSR    0 ];
	}
	
	Process ExpressionAssignmentProcess( G_rel )
	{
		Name	__none__;
		Expression	"G_rel_peak.Value * ( delta_Ca_i2.Value - delta_Ca_ith.Value ) / ( K_mrel.Value + delta_Ca_i2.Value - delta_Ca_ith.Value ) * ( 1.0 - exp( -( t_CICR.Value / tau_on.Value ) ) ) * exp( -( t_CICR.Value / tau_off.Value ) )";
		VariableReferenceList
			[ G_rel        :/calcium_fluxes_in_the_SR:G_rel        1 ]
			[ G_rel_peak   :/calcium_fluxes_in_the_SR:G_rel_peak   0 ]
			[ tau_on       :/calcium_fluxes_in_the_SR:tau_on       0 ]
			[ tau_off      :/calcium_fluxes_in_the_SR:tau_off      0 ]
			[ t_CICR       :/calcium_fluxes_in_the_SR:t_CICR       0 ]
			[ K_mrel       :/calcium_fluxes_in_the_SR:K_mrel       0 ]
			[ delta_Ca_i2  :/calcium_fluxes_in_the_SR:delta_Ca_i2  0 ]
			[ delta_Ca_ith :/calcium_fluxes_in_the_SR:delta_Ca_ith 0 ];
	}
	
	Process ExpressionAssignmentProcess( G_rel_peak )
	{
		Name	__none__;
		Expression	"piecewise( 0.0, lt( delta_Ca_i2.Value, delta_Ca_ith.Value ), G_rel_max.Value )";
		VariableReferenceList
			[ G_rel_peak   :/calcium_fluxes_in_the_SR:G_rel_peak   1 ]
			[ G_rel_max    :/calcium_fluxes_in_the_SR:G_rel_max    0 ]
			[ delta_Ca_i2  :/calcium_fluxes_in_the_SR:delta_Ca_i2  0 ]
			[ delta_Ca_ith :/calcium_fluxes_in_the_SR:delta_Ca_ith 0 ];
	}
	
	Process ExpressionAssignmentProcess( i_up )
	{
		Name	__none__;
		Expression	"I_up.Value * Cai.Value / ( Cai.Value + K_mup.Value )";
		VariableReferenceList
			[ i_up  :/calcium_fluxes_in_the_SR:i_up  1 ]
			[ K_mup :/calcium_fluxes_in_the_SR:K_mup 0 ]
			[ I_up  :/calcium_fluxes_in_the_SR:I_up  0 ]
			[ Cai   :/ionic_concentrations:Cai       0 ];
	}
	
	Process ExpressionAssignmentProcess( i_leak )
	{
		Name	__none__;
		Expression	"K_leak.Value * Ca_NSR.Value";
		VariableReferenceList
			[ i_leak :/calcium_fluxes_in_the_SR:i_leak 1 ]
			[ K_leak :/calcium_fluxes_in_the_SR:K_leak 0 ]
			[ Ca_NSR :/ionic_concentrations:Ca_NSR     0 ];
	}
	
	Process ExpressionAssignmentProcess( K_leak )
	{
		Name	__none__;
		Expression	"I_up.Value / Ca_NSR_max.Value";
		VariableReferenceList
			[ K_leak     :/calcium_fluxes_in_the_SR:K_leak     1 ]
			[ I_up       :/calcium_fluxes_in_the_SR:I_up       0 ]
			[ Ca_NSR_max :/calcium_fluxes_in_the_SR:Ca_NSR_max 0 ];
	}
	
	Process ExpressionAssignmentProcess( i_tr )
	{
		Name	__none__;
		Expression	"( Ca_NSR.Value - Ca_JSR.Value ) / tau_tr.Value";
		VariableReferenceList
			[ i_tr   :/calcium_fluxes_in_the_SR:i_tr   1 ]
			[ tau_tr :/calcium_fluxes_in_the_SR:tau_tr 0 ]
			[ Ca_JSR :/ionic_concentrations:Ca_JSR     0 ]
			[ Ca_NSR :/ionic_concentrations:Ca_NSR     0 ];
	}
	
	
}

System System( /L_type_Ca_channel_f_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_f )
	{
		Value	0.0199868986383;
		Name	__none__;
	}
	
	Variable Variable( beta_f )
	{
		Value	4.84058471617e-05;
		Name	__none__;
	}
	
	Variable Variable( f_infinity )
	{
		Value	0.997583972472;
		Name	__none__;
	}
	
	Variable Variable( tau_f )
	{
		Value	49.9118943128;
		Name	__none__;
	}
	
	Variable Variable( f )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( alpha_f )
	{
		Name	__none__;
		Expression	"f_infinity.Value / tau_f.Value";
		VariableReferenceList
			[ alpha_f    :/L_type_Ca_channel_f_gate:alpha_f    1 ]
			[ f_infinity :/L_type_Ca_channel_f_gate:f_infinity 0 ]
			[ tau_f      :/L_type_Ca_channel_f_gate:tau_f      0 ];
	}
	
	Process ExpressionAssignmentProcess( f_infinity )
	{
		Name	__none__;
		Expression	"1.0 / ( 1.0 + exp( ( V.Value + 35.06 ) / 8.6 ) ) + 0.6 / ( 1.0 + exp( ( 50.0 - V.Value ) / 20.0 ) )";
		VariableReferenceList
			[ f_infinity :/L_type_Ca_channel_f_gate:f_infinity 1 ]
			[ V          :/membrane:V                          0 ];
	}
	
	Process ExpressionAssignmentProcess( tau_f )
	{
		Name	__none__;
		Expression	"1.0 / ( 0.0197 * exp( -pow( 0.0337 * ( V.Value + 10.0 ), 2.0 ) ) + 0.02 )";
		VariableReferenceList
			[ tau_f :/L_type_Ca_channel_f_gate:tau_f 1 ]
			[ V     :/membrane:V                     0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_f )
	{
		Name	__none__;
		Expression	"( 1.0 - f_infinity.Value ) / tau_f.Value";
		VariableReferenceList
			[ beta_f     :/L_type_Ca_channel_f_gate:beta_f     1 ]
			[ f_infinity :/L_type_Ca_channel_f_gate:f_infinity 0 ]
			[ tau_f      :/L_type_Ca_channel_f_gate:tau_f      0 ];
	}
	
	Process ExpressionFluxProcess( f )
	{
		Name	__none__;
		Expression	"alpha_f.Value * ( 1.0 - f.Value ) - beta_f.Value * f.Value";
		VariableReferenceList
			[ f       :/L_type_Ca_channel_f_gate:f       1 ]
			[ alpha_f :/L_type_Ca_channel_f_gate:alpha_f 0 ]
			[ beta_f  :/L_type_Ca_channel_f_gate:beta_f  0 ];
	}
	
	
}

System System( /time_dependent_potassium_current_X_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_X )
	{
		Value	1.21131432021e-06;
		Name	__none__;
	}
	
	Variable Variable( beta_X )
	{
		Value	0.00732761365737;
		Name	__none__;
	}
	
	Variable Variable( X )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( alpha_X )
	{
		Name	__none__;
		Expression	"0.0000719 * ( V.Value + 30.0 ) / ( 1.0 - exp( -0.148 * ( V.Value + 30.0 ) ) )";
		VariableReferenceList
			[ alpha_X :/time_dependent_potassium_current_X_gate:alpha_X 1 ]
			[ V       :/membrane:V                                      0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_X )
	{
		Name	__none__;
		Expression	"0.000131 * ( V.Value + 30.0 ) / ( -1.0 + exp( 0.0687 * ( V.Value + 30.0 ) ) )";
		VariableReferenceList
			[ beta_X :/time_dependent_potassium_current_X_gate:beta_X 1 ]
			[ V      :/membrane:V                                     0 ];
	}
	
	Process ExpressionFluxProcess( X )
	{
		Name	__none__;
		Expression	"alpha_X.Value * ( 1.0 - X.Value ) - beta_X.Value * X.Value";
		VariableReferenceList
			[ X       :/time_dependent_potassium_current_X_gate:X       1 ]
			[ alpha_X :/time_dependent_potassium_current_X_gate:alpha_X 0 ]
			[ beta_X  :/time_dependent_potassium_current_X_gate:beta_X  0 ];
	}
	
	
}

System System( /ionic_concentrations )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( Am )
	{
		Value	200;
		Name	__none__;
	}
	
	Variable Variable( V_myo )
	{
		Value	0.68;
		Name	__none__;
	}
	
	Variable Variable( V_JSR )
	{
		Value	0.0048;
		Name	__none__;
	}
	
	Variable Variable( V_NSR )
	{
		Value	0.0552;
		Name	__none__;
	}
	
	Variable Variable( Nao )
	{
		Value	140.0;
		Name	__none__;
	}
	
	Variable Variable( Nai )
	{
		Value	10.0;
		Name	__none__;
	}
	
	Variable Variable( Cai )
	{
		Value	0.12e-3;
		Name	__none__;
	}
	
	Variable Variable( Cao )
	{
		Value	1.8;
		Name	__none__;
	}
	
	Variable Variable( Ko )
	{
		Value	5.4;
		Name	__none__;
	}
	
	Variable Variable( Ki )
	{
		Value	145.0;
		Name	__none__;
	}
	
	Variable Variable( Ca_JSR )
	{
		Value	1.8;
		Name	__none__;
	}
	
	Variable Variable( Ca_NSR )
	{
		Value	1.8;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionFluxProcess( Nai )
	{
		Name	__none__;
		Expression	"-( i_Na.Value + i_CaNa.Value + i_Na_b.Value + i_ns_Na.Value + i_NaCa.Value * 3.0 + i_NaK.Value * 3.0 ) * Am.Value / ( V_myo.Value * F.Value )";
		VariableReferenceList
			[ Nai     :/ionic_concentrations:Nai                       1 ]
			[ Am      :/ionic_concentrations:Am                        0 ]
			[ V_myo   :/ionic_concentrations:V_myo                     0 ]
			[ F       :/membrane:F                                     0 ]
			[ i_Na    :/fast_sodium_current:i_Na                       0 ]
			[ i_CaNa  :/L_type_Ca_channel:i_CaNa                       0 ]
			[ i_Na_b  :/sodium_background_current:i_Na_b               0 ]
			[ i_ns_Na :/non_specific_calcium_activated_current:i_ns_Na 0 ]
			[ i_NaCa  :/Na_Ca_exchanger:i_NaCa                         0 ]
			[ i_NaK   :/sodium_potassium_pump:i_NaK                    0 ];
	}
	
	Process ExpressionFluxProcess( Cai )
	{
		Name	__none__;
		Expression	"-( i_CaCa.Value + i_p_Ca.Value + i_Ca_b.Value - i_NaCa.Value ) * Am.Value / ( 2.0 * V_myo.Value * F.Value ) + i_rel.Value * V_JSR.Value / V_myo.Value + ( i_leak.Value - i_up.Value ) * V_NSR.Value / V_myo.Value";
		VariableReferenceList
			[ Cai    :/ionic_concentrations:Cai          1 ]
			[ Am     :/ionic_concentrations:Am           0 ]
			[ V_myo  :/ionic_concentrations:V_myo        0 ]
			[ V_JSR  :/ionic_concentrations:V_JSR        0 ]
			[ V_NSR  :/ionic_concentrations:V_NSR        0 ]
			[ F      :/membrane:F                        0 ]
			[ i_NaCa :/Na_Ca_exchanger:i_NaCa            0 ]
			[ i_CaCa :/L_type_Ca_channel:i_CaCa          0 ]
			[ i_p_Ca :/sarcolemmal_calcium_pump:i_p_Ca   0 ]
			[ i_Ca_b :/calcium_background_current:i_Ca_b 0 ]
			[ i_rel  :/calcium_fluxes_in_the_SR:i_rel    0 ]
			[ i_leak :/calcium_fluxes_in_the_SR:i_leak   0 ]
			[ i_up   :/calcium_fluxes_in_the_SR:i_up     0 ];
	}
	
	Process ExpressionFluxProcess( Ki )
	{
		Name	__none__;
		Expression	"-( i_CaK.Value + i_K.Value + i_K1.Value + i_Kp.Value + i_ns_K.Value + -( i_NaK.Value * 2.0 ) ) * Am.Value / ( V_myo.Value * F.Value )";
		VariableReferenceList
			[ Ki     :/ionic_concentrations:Ki                       1 ]
			[ Am     :/ionic_concentrations:Am                       0 ]
			[ V_myo  :/ionic_concentrations:V_myo                    0 ]
			[ F      :/membrane:F                                    0 ]
			[ i_NaK  :/sodium_potassium_pump:i_NaK                   0 ]
			[ i_CaK  :/L_type_Ca_channel:i_CaK                       0 ]
			[ i_K    :/time_dependent_potassium_current:i_K          0 ]
			[ i_K1   :/time_independent_potassium_current:i_K1       0 ]
			[ i_Kp   :/plateau_potassium_current:i_Kp                0 ]
			[ i_ns_K :/non_specific_calcium_activated_current:i_ns_K 0 ];
	}
	
	Process ExpressionFluxProcess( Ca_JSR )
	{
		Name	__none__;
		Expression	"-( i_rel.Value - i_tr.Value * V_NSR.Value / V_JSR.Value )";
		VariableReferenceList
			[ Ca_JSR :/ionic_concentrations:Ca_JSR    1 ]
			[ V_JSR  :/ionic_concentrations:V_JSR     0 ]
			[ V_NSR  :/ionic_concentrations:V_NSR     0 ]
			[ i_tr   :/calcium_fluxes_in_the_SR:i_tr  0 ]
			[ i_rel  :/calcium_fluxes_in_the_SR:i_rel 0 ];
	}
	
	Process ExpressionFluxProcess( Ca_NSR )
	{
		Name	__none__;
		Expression	"-( i_leak.Value + i_tr.Value - i_up.Value )";
		VariableReferenceList
			[ Ca_NSR :/ionic_concentrations:Ca_NSR     1 ]
			[ i_tr   :/calcium_fluxes_in_the_SR:i_tr   0 ]
			[ i_leak :/calcium_fluxes_in_the_SR:i_leak 0 ]
			[ i_up   :/calcium_fluxes_in_the_SR:i_up   0 ];
	}
	
	
}

System System( /Na_Ca_exchanger )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( K_NaCa )
	{
		Value	20.0;
		Name	__none__;
	}
	
	Variable Variable( K_mNa )
	{
		Value	87.5;
		Name	__none__;
	}
	
	Variable Variable( K_mCa )
	{
		Value	1.38;
		Name	__none__;
	}
	
	Variable Variable( K_sat )
	{
		Value	0.1;
		Name	__none__;
	}
	
	Variable Variable( eta )
	{
		Value	0.35;
		Name	__none__;
	}
	
	Variable Variable( i_NaCa )
	{
		Value	-0.00206825717859;
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
		Expression	"K_NaCa.Value * 1.0 / ( pow( K_mNa.Value, 3.0 ) + pow( Nao.Value, 3.0 ) ) * 1.0 / ( K_mCa.Value + Cao.Value ) * 1.0 / ( 1.0 + K_sat.Value * exp( ( eta.Value - 1.0 ) * V.Value * F.Value / ( R.Value * T.Value ) ) ) * ( exp( eta.Value * V.Value * F.Value / ( R.Value * T.Value ) ) * pow( Nai.Value, 3.0 ) * Cao.Value - exp( ( eta.Value - 1.0 ) * V.Value * F.Value / ( R.Value * T.Value ) ) * pow( Nao.Value, 3.0 ) * Cai.Value )";
		VariableReferenceList
			[ i_NaCa :/Na_Ca_exchanger:i_NaCa   1 ]
			[ K_NaCa :/Na_Ca_exchanger:K_NaCa   0 ]
			[ K_mNa  :/Na_Ca_exchanger:K_mNa    0 ]
			[ K_mCa  :/Na_Ca_exchanger:K_mCa    0 ]
			[ K_sat  :/Na_Ca_exchanger:K_sat    0 ]
			[ eta    :/Na_Ca_exchanger:eta      0 ]
			[ V      :/membrane:V               0 ]
			[ R      :/membrane:R               0 ]
			[ T      :/membrane:T               0 ]
			[ F      :/membrane:F               0 ]
			[ Nai    :/ionic_concentrations:Nai 0 ]
			[ Nao    :/ionic_concentrations:Nao 0 ]
			[ Cai    :/ionic_concentrations:Cai 0 ]
			[ Cao    :/ionic_concentrations:Cao 0 ];
	}
	
	
}

System System( /plateau_potassium_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( E_Kp )
	{
		Value	-87.5710823128;
		Name	__none__;
	}
	
	Variable Variable( g_Kp )
	{
		Value	1.83e-4;
		Name	__none__;
	}
	
	Variable Variable( Kp )
	{
		Value	2.04367767158e-07;
		Name	__none__;
	}
	
	Variable Variable( i_Kp )
	{
		Value	1.10218819639e-10;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( E_Kp )
	{
		Name	__none__;
		Expression	"E_K1.Value";
		VariableReferenceList
			[ E_Kp :/plateau_potassium_current:E_Kp          1 ]
			[ E_K1 :/time_independent_potassium_current:E_K1 0 ];
	}
	
	Process ExpressionAssignmentProcess( Kp )
	{
		Name	__none__;
		Expression	"1.0 / ( 1.0 + exp( ( 7.488 - V.Value ) / 5.98 ) )";
		VariableReferenceList
			[ Kp :/plateau_potassium_current:Kp 1 ]
			[ V  :/membrane:V                   0 ];
	}
	
	Process ExpressionAssignmentProcess( i_Kp )
	{
		Name	__none__;
		Expression	"g_Kp.Value * Kp.Value * ( V.Value - E_Kp.Value )";
		VariableReferenceList
			[ i_Kp :/plateau_potassium_current:i_Kp 1 ]
			[ E_Kp :/plateau_potassium_current:E_Kp 0 ]
			[ g_Kp :/plateau_potassium_current:g_Kp 0 ]
			[ Kp   :/plateau_potassium_current:Kp   0 ]
			[ V    :/membrane:V                     0 ];
	}
	
	
}

System System( /environment )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( time )
	{
		Value	0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	
}

System System( /time_dependent_potassium_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_K_max )
	{
		Value	2.82e-3;
		Name	__none__;
	}
	
	Variable Variable( g_K )
	{
		Value	0.00282;
		Name	__none__;
	}
	
	Variable Variable( E_K )
	{
		Value	-77.2567029659;
		Name	__none__;
	}
	
	Variable Variable( PR_NaK )
	{
		Value	0.01833;
		Name	__none__;
	}
	
	Variable Variable( i_K )
	{
		Value	-0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( g_K )
	{
		Name	__none__;
		Expression	"g_K_max.Value * sqrt( Ko.Value / 5.4 )";
		VariableReferenceList
			[ g_K_max :/time_dependent_potassium_current:g_K_max 0 ]
			[ g_K     :/time_dependent_potassium_current:g_K     1 ]
			[ Ko      :/ionic_concentrations:Ko                  0 ];
	}
	
	Process ExpressionAssignmentProcess( E_K )
	{
		Name	__none__;
		Expression	"R.Value * T.Value / F.Value * log( ( Ko.Value + PR_NaK.Value * Nao.Value ) / ( Ki.Value + PR_NaK.Value * Nai.Value ) )";
		VariableReferenceList
			[ E_K    :/time_dependent_potassium_current:E_K    1 ]
			[ PR_NaK :/time_dependent_potassium_current:PR_NaK 0 ]
			[ R      :/membrane:R                              0 ]
			[ T      :/membrane:T                              0 ]
			[ F      :/membrane:F                              0 ]
			[ Ko     :/ionic_concentrations:Ko                 0 ]
			[ Ki     :/ionic_concentrations:Ki                 0 ]
			[ Nao    :/ionic_concentrations:Nao                0 ]
			[ Nai    :/ionic_concentrations:Nai                0 ];
	}
	
	Process ExpressionAssignmentProcess( i_K )
	{
		Name	__none__;
		Expression	"g_K.Value * pow( X.Value, 2.0 ) * Xi.Value * ( V.Value - E_K.Value )";
		VariableReferenceList
			[ i_K :/time_dependent_potassium_current:i_K        1 ]
			[ g_K :/time_dependent_potassium_current:g_K        0 ]
			[ E_K :/time_dependent_potassium_current:E_K        0 ]
			[ V   :/membrane:V                                  0 ]
			[ X   :/time_dependent_potassium_current_X_gate:X   0 ]
			[ Xi  :/time_dependent_potassium_current_Xi_gate:Xi 0 ];
	}
	
	
}

System System( /membrane )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( dV_dt )
	{
		Value	-0.582389153035;
		Name	__none__;
	}
	
	Variable Variable( Cm )
	{
		Value	0.01;
		Name	__none__;
	}
	
	Variable Variable( I_st )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( stimPeriod )
	{
		Value	1e3;
		Name	__none__;
	}
	
	Variable Variable( stimDuration )
	{
		Value	0.5;
		Name	__none__;
	}
	
	Variable Variable( stimCurrent )
	{
		Value	0.5;
		Name	__none__;
	}
	
	Variable Variable( V )
	{
		Value	-84.624;
		Name	__none__;
	}
	
	Variable Variable( R )
	{
		Value	8.3145e3;
		Name	__none__;
	}
	
	Variable Variable( T )
	{
		Value	310.0;
		Name	__none__;
	}
	
	Variable Variable( F )
	{
		Value	96845.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( dV_dt )
	{
		Name	__none__;
		Expression	"( I_st.Value - ( i_Na.Value + i_Ca_L.Value + i_K.Value + i_K1.Value + i_Kp.Value + i_NaCa.Value + i_p_Ca.Value + i_Na_b.Value + i_Ca_b.Value + i_NaK.Value + i_ns_Ca.Value ) ) / Cm.Value";
		VariableReferenceList
			[ dV_dt   :/membrane:dV_dt                                 1 ]
			[ Cm      :/membrane:Cm                                    0 ]
			[ I_st    :/membrane:I_st                                  0 ]
			[ i_Na    :/fast_sodium_current:i_Na                       0 ]
			[ i_Ca_L  :/L_type_Ca_channel:i_Ca_L                       0 ]
			[ i_K     :/time_dependent_potassium_current:i_K           0 ]
			[ i_NaCa  :/Na_Ca_exchanger:i_NaCa                         0 ]
			[ i_K1    :/time_independent_potassium_current:i_K1        0 ]
			[ i_Kp    :/plateau_potassium_current:i_Kp                 0 ]
			[ i_p_Ca  :/sarcolemmal_calcium_pump:i_p_Ca                0 ]
			[ i_Na_b  :/sodium_background_current:i_Na_b               0 ]
			[ i_Ca_b  :/calcium_background_current:i_Ca_b              0 ]
			[ i_NaK   :/sodium_potassium_pump:i_NaK                    0 ]
			[ i_ns_Ca :/non_specific_calcium_activated_current:i_ns_Ca 0 ];
	}
	
	Process ExpressionAssignmentProcess( I_st )
	{
		Name	__none__;
		Expression	"piecewise( stimCurrent.Value, lt( rem( <t>, stimPeriod.Value ), stimDuration.Value ), 0.0 )";
		VariableReferenceList
			[ I_st         :/membrane:I_st         1 ]
			[ time         :/environment:time      0 ]
			[ stimPeriod   :/membrane:stimPeriod   0 ]
			[ stimDuration :/membrane:stimDuration 0 ]
			[ stimCurrent  :/membrane:stimCurrent  0 ];
	}
	
	Process ExpressionFluxProcess( V )
	{
		Name	__none__;
		Expression	"dV_dt.Value";
		VariableReferenceList
			[ V     :/membrane:V     1 ]
			[ dV_dt :/membrane:dV_dt 0 ];
	}
	
	
}

System System( /fast_sodium_current_j_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_j )
	{
		Value	0.0615749606566;
		Name	__none__;
	}
	
	Variable Variable( beta_j )
	{
		Value	0.000641219729143;
		Name	__none__;
	}
	
	Variable Variable( j )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( alpha_j )
	{
		Name	__none__;
		Expression	"piecewise( ( -127140.0 * exp( 0.2444 * V.Value ) - 0.00003474 * exp( -0.04391 * V.Value ) ) * ( V.Value + 37.78 ) / ( 1.0 + exp( 0.311 * ( V.Value + 79.23 ) ) ), lt( V.Value, -40.0 ), 0.0 )";
		VariableReferenceList
			[ alpha_j :/fast_sodium_current_j_gate:alpha_j 1 ]
			[ V       :/membrane:V                         0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_j )
	{
		Name	__none__;
		Expression	"piecewise( 0.1212 * exp( -0.01052 * V.Value ) / ( 1.0 + exp( -0.1378 * ( V.Value + 40.14 ) ) ), lt( V.Value, -40.0 ), 0.3 * exp( -0.0000002535 * V.Value ) / ( 1.0 + exp( -0.1 * ( V.Value + 32.0 ) ) ) )";
		VariableReferenceList
			[ beta_j :/fast_sodium_current_j_gate:beta_j 1 ]
			[ V      :/membrane:V                        0 ];
	}
	
	Process ExpressionFluxProcess( j )
	{
		Name	__none__;
		Expression	"alpha_j.Value * ( 1.0 - j.Value ) - beta_j.Value * j.Value";
		VariableReferenceList
			[ j       :/fast_sodium_current_j_gate:j       1 ]
			[ alpha_j :/fast_sodium_current_j_gate:alpha_j 0 ]
			[ beta_j  :/fast_sodium_current_j_gate:beta_j  0 ];
	}
	
	
}

System System( /time_independent_potassium_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_K1_max )
	{
		Value	7.5e-3;
		Name	__none__;
	}
	
	Variable Variable( g_K1 )
	{
		Value	0.0075;
		Name	__none__;
	}
	
	Variable Variable( i_K1 )
	{
		Value	0.0114545544916;
		Name	__none__;
	}
	
	Variable Variable( E_K1 )
	{
		Value	-87.5710823128;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( g_K1 )
	{
		Name	__none__;
		Expression	"g_K1_max.Value * sqrt( Ko.Value / 5.4 )";
		VariableReferenceList
			[ g_K1_max :/time_independent_potassium_current:g_K1_max 0 ]
			[ g_K1     :/time_independent_potassium_current:g_K1     1 ]
			[ Ko       :/ionic_concentrations:Ko                     0 ];
	}
	
	Process ExpressionAssignmentProcess( E_K1 )
	{
		Name	__none__;
		Expression	"R.Value * T.Value / F.Value * log( Ko.Value / Ki.Value )";
		VariableReferenceList
			[ E_K1 :/time_independent_potassium_current:E_K1 1 ]
			[ Ko   :/ionic_concentrations:Ko                 0 ]
			[ Ki   :/ionic_concentrations:Ki                 0 ]
			[ R    :/membrane:R                              0 ]
			[ T    :/membrane:T                              0 ]
			[ F    :/membrane:F                              0 ];
	}
	
	Process ExpressionAssignmentProcess( i_K1 )
	{
		Name	__none__;
		Expression	"g_K1.Value * K1_infinity.Value * ( V.Value - E_K1.Value )";
		VariableReferenceList
			[ i_K1        :/time_independent_potassium_current:i_K1                1 ]
			[ E_K1        :/time_independent_potassium_current:E_K1                0 ]
			[ g_K1        :/time_independent_potassium_current:g_K1                0 ]
			[ V           :/membrane:V                                             0 ]
			[ K1_infinity :/time_independent_potassium_current_K1_gate:K1_infinity 0 ];
	}
	
	
}

System System( /L_type_Ca_channel_f_Ca_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( Km_Ca )
	{
		Value	0.6e-3;
		Name	__none__;
	}
	
	Variable Variable( f_Ca )
	{
		Value	0.961538461538;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( f_Ca )
	{
		Name	__none__;
		Expression	"1.0 / ( 1.0 + pow( Cai.Value / Km_Ca.Value, 2.0 ) )";
		VariableReferenceList
			[ f_Ca  :/L_type_Ca_channel_f_Ca_gate:f_Ca  1 ]
			[ Km_Ca :/L_type_Ca_channel_f_Ca_gate:Km_Ca 0 ]
			[ Cai   :/ionic_concentrations:Cai          0 ];
	}
	
	
}

System System( /L_type_Ca_channel )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( I_CaCa )
	{
		Value	-4.07762659402;
		Name	__none__;
	}
	
	Variable Variable( I_CaK )
	{
		Value	0.000294073026221;
		Name	__none__;
	}
	
	Variable Variable( I_CaNa )
	{
		Value	-0.227041322474;
		Name	__none__;
	}
	
	Variable Variable( P_Ca )
	{
		Value	5.4e-6;
		Name	__none__;
	}
	
	Variable Variable( P_Na )
	{
		Value	6.75e-9;
		Name	__none__;
	}
	
	Variable Variable( P_K )
	{
		Value	1.93e-9;
		Name	__none__;
	}
	
	Variable Variable( gamma_Cai )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Variable Variable( gamma_Cao )
	{
		Value	0.34;
		Name	__none__;
	}
	
	Variable Variable( i_Ca_L )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( i_CaCa )
	{
		Value	-0.0;
		Name	__none__;
	}
	
	Variable Variable( i_CaNa )
	{
		Value	-0.0;
		Name	__none__;
	}
	
	Variable Variable( i_CaK )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( gamma_Nao )
	{
		Value	0.75;
		Name	__none__;
	}
	
	Variable Variable( gamma_Nai )
	{
		Value	0.75;
		Name	__none__;
	}
	
	Variable Variable( gamma_Ko )
	{
		Value	0.75;
		Name	__none__;
	}
	
	Variable Variable( gamma_Ki )
	{
		Value	0.75;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( i_CaCa )
	{
		Name	__none__;
		Expression	"d.Value * f.Value * f_Ca.Value * I_CaCa.Value";
		VariableReferenceList
			[ i_CaCa :/L_type_Ca_channel:i_CaCa         1 ]
			[ I_CaCa :/L_type_Ca_channel:I_CaCa         0 ]
			[ d      :/L_type_Ca_channel_d_gate:d       0 ]
			[ f      :/L_type_Ca_channel_f_gate:f       0 ]
			[ f_Ca   :/L_type_Ca_channel_f_Ca_gate:f_Ca 0 ];
	}
	
	Process ExpressionAssignmentProcess( i_CaNa )
	{
		Name	__none__;
		Expression	"d.Value * f.Value * f_Ca.Value * I_CaNa.Value";
		VariableReferenceList
			[ i_CaNa :/L_type_Ca_channel:i_CaNa         1 ]
			[ I_CaNa :/L_type_Ca_channel:I_CaNa         0 ]
			[ d      :/L_type_Ca_channel_d_gate:d       0 ]
			[ f      :/L_type_Ca_channel_f_gate:f       0 ]
			[ f_Ca   :/L_type_Ca_channel_f_Ca_gate:f_Ca 0 ];
	}
	
	Process ExpressionAssignmentProcess( i_CaK )
	{
		Name	__none__;
		Expression	"d.Value * f.Value * f_Ca.Value * I_CaK.Value";
		VariableReferenceList
			[ i_CaK :/L_type_Ca_channel:i_CaK          1 ]
			[ I_CaK :/L_type_Ca_channel:I_CaK          0 ]
			[ d     :/L_type_Ca_channel_d_gate:d       0 ]
			[ f     :/L_type_Ca_channel_f_gate:f       0 ]
			[ f_Ca  :/L_type_Ca_channel_f_Ca_gate:f_Ca 0 ];
	}
	
	Process ExpressionAssignmentProcess( I_CaCa )
	{
		Name	__none__;
		Expression	"P_Ca.Value * pow( 2.0, 2.0 ) * V.Value * pow( F.Value, 2.0 ) / ( R.Value * T.Value ) * ( gamma_Cai.Value * Cai.Value * exp( 2.0 * V.Value * F.Value / ( R.Value * T.Value ) ) - gamma_Cao.Value * Cao.Value ) / ( exp( 2.0 * V.Value * F.Value / ( R.Value * T.Value ) ) - 1.0 )";
		VariableReferenceList
			[ I_CaCa    :/L_type_Ca_channel:I_CaCa    1 ]
			[ P_Ca      :/L_type_Ca_channel:P_Ca      0 ]
			[ gamma_Cai :/L_type_Ca_channel:gamma_Cai 0 ]
			[ gamma_Cao :/L_type_Ca_channel:gamma_Cao 0 ]
			[ V         :/membrane:V                  0 ]
			[ Cai       :/ionic_concentrations:Cai    0 ]
			[ R         :/membrane:R                  0 ]
			[ T         :/membrane:T                  0 ]
			[ F         :/membrane:F                  0 ]
			[ Cao       :/ionic_concentrations:Cao    0 ];
	}
	
	Process ExpressionAssignmentProcess( I_CaNa )
	{
		Name	__none__;
		Expression	"P_Na.Value * pow( 1.0, 2.0 ) * V.Value * pow( F.Value, 2.0 ) / ( R.Value * T.Value ) * ( gamma_Nai.Value * Nai.Value * exp( 1.0 * V.Value * F.Value / ( R.Value * T.Value ) ) - gamma_Nao.Value * Nao.Value ) / ( exp( 1.0 * V.Value * F.Value / ( R.Value * T.Value ) ) - 1.0 )";
		VariableReferenceList
			[ gamma_Nai :/L_type_Ca_channel:gamma_Nai 0 ]
			[ gamma_Nao :/L_type_Ca_channel:gamma_Nao 0 ]
			[ I_CaNa    :/L_type_Ca_channel:I_CaNa    1 ]
			[ P_Na      :/L_type_Ca_channel:P_Na      0 ]
			[ V         :/membrane:V                  0 ]
			[ R         :/membrane:R                  0 ]
			[ T         :/membrane:T                  0 ]
			[ F         :/membrane:F                  0 ]
			[ Nao       :/ionic_concentrations:Nao    0 ]
			[ Nai       :/ionic_concentrations:Nai    0 ];
	}
	
	Process ExpressionAssignmentProcess( I_CaK )
	{
		Name	__none__;
		Expression	"P_K.Value * pow( 1.0, 2.0 ) * V.Value * pow( F.Value, 2.0 ) / ( R.Value * T.Value ) * ( gamma_Ki.Value * Ki.Value * exp( 1.0 * V.Value * F.Value / ( R.Value * T.Value ) ) - gamma_Ko.Value * Ko.Value ) / ( exp( 1.0 * V.Value * F.Value / ( R.Value * T.Value ) ) - 1.0 )";
		VariableReferenceList
			[ gamma_Ki :/L_type_Ca_channel:gamma_Ki 0 ]
			[ gamma_Ko :/L_type_Ca_channel:gamma_Ko 0 ]
			[ I_CaK    :/L_type_Ca_channel:I_CaK    1 ]
			[ P_K      :/L_type_Ca_channel:P_K      0 ]
			[ V        :/membrane:V                 0 ]
			[ R        :/membrane:R                 0 ]
			[ T        :/membrane:T                 0 ]
			[ F        :/membrane:F                 0 ]
			[ Ko       :/ionic_concentrations:Ko    0 ]
			[ Ki       :/ionic_concentrations:Ki    0 ];
	}
	
	Process ExpressionAssignmentProcess( i_Ca_L )
	{
		Name	__none__;
		Expression	"i_CaCa.Value + i_CaK.Value + i_CaNa.Value";
		VariableReferenceList
			[ i_Ca_L :/L_type_Ca_channel:i_Ca_L 1 ]
			[ i_CaCa :/L_type_Ca_channel:i_CaCa 0 ]
			[ i_CaK  :/L_type_Ca_channel:i_CaK  0 ]
			[ i_CaNa :/L_type_Ca_channel:i_CaNa 0 ];
	}
	
	
}

System System( /fast_sodium_current_m_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_m )
	{
		Value	0.289141177603;
		Name	__none__;
	}
	
	Variable Variable( beta_m )
	{
		Value	175.451432161;
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
		Expression	"0.32 * ( V.Value + 47.13 ) / ( 1.0 - exp( -0.1 * ( V.Value + 47.13 ) ) )";
		VariableReferenceList
			[ alpha_m :/fast_sodium_current_m_gate:alpha_m 1 ]
			[ V       :/membrane:V                         0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_m )
	{
		Name	__none__;
		Expression	"0.08 * exp( -V.Value / 11.0 )";
		VariableReferenceList
			[ beta_m :/fast_sodium_current_m_gate:beta_m 1 ]
			[ V      :/membrane:V                        0 ];
	}
	
	Process ExpressionFluxProcess( m )
	{
		Name	__none__;
		Expression	"alpha_m.Value * ( 1.0 - m.Value ) - beta_m.Value * m.Value";
		VariableReferenceList
			[ m       :/fast_sodium_current_m_gate:m       1 ]
			[ alpha_m :/fast_sodium_current_m_gate:alpha_m 0 ]
			[ beta_m  :/fast_sodium_current_m_gate:beta_m  0 ];
	}
	
	
}

System System( /sarcolemmal_calcium_pump )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( K_mpCa )
	{
		Value	0.5e-3;
		Name	__none__;
	}
	
	Variable Variable( I_pCa )
	{
		Value	1.15e-2;
		Name	__none__;
	}
	
	Variable Variable( i_p_Ca )
	{
		Value	0.00222580645161;
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
		Expression	"I_pCa.Value * Cai.Value / ( K_mpCa.Value + Cai.Value )";
		VariableReferenceList
			[ i_p_Ca :/sarcolemmal_calcium_pump:i_p_Ca 1 ]
			[ K_mpCa :/sarcolemmal_calcium_pump:K_mpCa 0 ]
			[ I_pCa  :/sarcolemmal_calcium_pump:I_pCa  0 ]
			[ Cai    :/ionic_concentrations:Cai        0 ];
	}
	
	
}

System System( /time_independent_potassium_current_K1_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_K1 )
	{
		Value	1.019998485;
		Name	__none__;
	}
	
	Variable Variable( beta_K1 )
	{
		Value	0.948227012;
		Name	__none__;
	}
	
	Variable Variable( K1_infinity )
	{
		Value	0.518232533089;
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
		Expression	"1.02 / ( 1.0 + exp( 0.2385 * ( V.Value - E_K1.Value - 59.215 ) ) )";
		VariableReferenceList
			[ alpha_K1 :/time_independent_potassium_current_K1_gate:alpha_K1 1 ]
			[ V        :/membrane:V                                          0 ]
			[ E_K1     :/time_independent_potassium_current:E_K1             0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_K1 )
	{
		Name	__none__;
		Expression	"( 0.49124 * exp( 0.08032 * ( V.Value + 5.476 - E_K1.Value ) ) + exp( 0.06175 * ( V.Value - ( E_K1.Value + 594.31 ) ) ) ) / ( 1.0 + exp( -0.5143 * ( V.Value - E_K1.Value + 4.753 ) ) )";
		VariableReferenceList
			[ beta_K1 :/time_independent_potassium_current_K1_gate:beta_K1 1 ]
			[ V       :/membrane:V                                         0 ]
			[ E_K1    :/time_independent_potassium_current:E_K1            0 ];
	}
	
	Process ExpressionAssignmentProcess( K1_infinity )
	{
		Name	__none__;
		Expression	"alpha_K1.Value / ( alpha_K1.Value + beta_K1.Value )";
		VariableReferenceList
			[ K1_infinity :/time_independent_potassium_current_K1_gate:K1_infinity 1 ]
			[ alpha_K1    :/time_independent_potassium_current_K1_gate:alpha_K1    0 ]
			[ beta_K1     :/time_independent_potassium_current_K1_gate:beta_K1     0 ];
	}
	
	
}

System System( /sodium_background_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( g_Nab )
	{
		Value	1.41e-5;
		Name	__none__;
	}
	
	Variable Variable( E_NaN )
	{
		Value	70.2375659228;
		Name	__none__;
	}
	
	Variable Variable( i_Na_b )
	{
		Value	-0.00218354807951;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( E_NaN )
	{
		Name	__none__;
		Expression	"E_Na.Value";
		VariableReferenceList
			[ E_NaN :/sodium_background_current:E_NaN 1 ]
			[ E_Na  :/fast_sodium_current:E_Na        0 ];
	}
	
	Process ExpressionAssignmentProcess( i_Na_b )
	{
		Name	__none__;
		Expression	"g_Nab.Value * ( V.Value - E_NaN.Value )";
		VariableReferenceList
			[ i_Na_b :/sodium_background_current:i_Na_b 1 ]
			[ g_Nab  :/sodium_background_current:g_Nab  0 ]
			[ E_NaN  :/sodium_background_current:E_NaN  0 ]
			[ V      :/membrane:V                       0 ];
	}
	
	
}

System System( /L_type_Ca_channel_d_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_d )
	{
		Value	1.67198653489e-05;
		Name	__none__;
	}
	
	Variable Variable( beta_d )
	{
		Value	2.61185671987;
		Name	__none__;
	}
	
	Variable Variable( d_infinity )
	{
		Value	6.40148373753e-06;
		Name	__none__;
	}
	
	Variable Variable( tau_d )
	{
		Value	0.38286694324;
		Name	__none__;
	}
	
	Variable Variable( d )
	{
		Value	0.0;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( alpha_d )
	{
		Name	__none__;
		Expression	"d_infinity.Value / tau_d.Value";
		VariableReferenceList
			[ alpha_d    :/L_type_Ca_channel_d_gate:alpha_d    1 ]
			[ d_infinity :/L_type_Ca_channel_d_gate:d_infinity 0 ]
			[ tau_d      :/L_type_Ca_channel_d_gate:tau_d      0 ];
	}
	
	Process ExpressionAssignmentProcess( d_infinity )
	{
		Name	__none__;
		Expression	"1.0 / ( 1.0 + exp( -( ( V.Value + 10.0 ) / 6.24 ) ) )";
		VariableReferenceList
			[ d_infinity :/L_type_Ca_channel_d_gate:d_infinity 1 ]
			[ V          :/membrane:V                          0 ];
	}
	
	Process ExpressionAssignmentProcess( tau_d )
	{
		Name	__none__;
		Expression	"d_infinity.Value * ( 1.0 - exp( -( ( V.Value + 10.0 ) / 6.24 ) ) ) / ( 0.035 * ( V.Value + 10.0 ) )";
		VariableReferenceList
			[ d_infinity :/L_type_Ca_channel_d_gate:d_infinity 0 ]
			[ tau_d      :/L_type_Ca_channel_d_gate:tau_d      1 ]
			[ V          :/membrane:V                          0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_d )
	{
		Name	__none__;
		Expression	"( 1.0 - d_infinity.Value ) / tau_d.Value";
		VariableReferenceList
			[ beta_d     :/L_type_Ca_channel_d_gate:beta_d     1 ]
			[ d_infinity :/L_type_Ca_channel_d_gate:d_infinity 0 ]
			[ tau_d      :/L_type_Ca_channel_d_gate:tau_d      0 ];
	}
	
	Process ExpressionFluxProcess( d )
	{
		Name	__none__;
		Expression	"alpha_d.Value * ( 1.0 - d.Value ) - beta_d.Value * d.Value";
		VariableReferenceList
			[ d       :/L_type_Ca_channel_d_gate:d       1 ]
			[ alpha_d :/L_type_Ca_channel_d_gate:alpha_d 0 ]
			[ beta_d  :/L_type_Ca_channel_d_gate:beta_d  0 ];
	}
	
	
}

System System( /non_specific_calcium_activated_current )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( P_ns_Ca )
	{
		Value	1.75e-9;
		Name	__none__;
	}
	
	Variable Variable( I_ns_Na )
	{
		Value	-0.0578333368142;
		Name	__none__;
	}
	
	Variable Variable( I_ns_K )
	{
		Value	0.00042708696978;
		Name	__none__;
	}
	
	Variable Variable( K_m_ns_Ca )
	{
		Value	1.2e-3;
		Name	__none__;
	}
	
	Variable Variable( Vns )
	{
		Value	-82.9223515656;
		Name	__none__;
	}
	
	Variable Variable( EnsCa )
	{
		Value	-1.70164843443;
		Name	__none__;
	}
	
	Variable Variable( i_ns_Ca )
	{
		Value	-5.73489009435e-05;
		Name	__none__;
	}
	
	Variable Variable( i_ns_Na )
	{
		Value	-5.77755612529e-05;
		Name	__none__;
	}
	
	Variable Variable( i_ns_K )
	{
		Value	4.2666030947e-07;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( EnsCa )
	{
		Name	__none__;
		Expression	"R.Value * T.Value / F.Value * log( ( Ko.Value + Nao.Value ) / ( Ki.Value + Nai.Value ) )";
		VariableReferenceList
			[ R     :/membrane:R                                   0 ]
			[ T     :/membrane:T                                   0 ]
			[ F     :/membrane:F                                   0 ]
			[ Nao   :/ionic_concentrations:Nao                     0 ]
			[ Ko    :/ionic_concentrations:Ko                      0 ]
			[ Nai   :/ionic_concentrations:Nai                     0 ]
			[ Ki    :/ionic_concentrations:Ki                      0 ]
			[ EnsCa :/non_specific_calcium_activated_current:EnsCa 1 ];
	}
	
	Process ExpressionAssignmentProcess( Vns )
	{
		Name	__none__;
		Expression	"V.Value - EnsCa.Value";
		VariableReferenceList
			[ V     :/membrane:V                                   0 ]
			[ Vns   :/non_specific_calcium_activated_current:Vns   1 ]
			[ EnsCa :/non_specific_calcium_activated_current:EnsCa 0 ];
	}
	
	Process ExpressionAssignmentProcess( i_ns_Na )
	{
		Name	__none__;
		Expression	"I_ns_Na.Value * 1.0 / ( 1.0 + pow( K_m_ns_Ca.Value / Cai.Value, 3.0 ) )";
		VariableReferenceList
			[ i_ns_Na   :/non_specific_calcium_activated_current:i_ns_Na   1 ]
			[ I_ns_Na   :/non_specific_calcium_activated_current:I_ns_Na   0 ]
			[ K_m_ns_Ca :/non_specific_calcium_activated_current:K_m_ns_Ca 0 ]
			[ Cai       :/ionic_concentrations:Cai                         0 ];
	}
	
	Process ExpressionAssignmentProcess( i_ns_K )
	{
		Name	__none__;
		Expression	"I_ns_K.Value * 1.0 / ( 1.0 + pow( K_m_ns_Ca.Value / Cai.Value, 3.0 ) )";
		VariableReferenceList
			[ i_ns_K    :/non_specific_calcium_activated_current:i_ns_K    1 ]
			[ I_ns_K    :/non_specific_calcium_activated_current:I_ns_K    0 ]
			[ K_m_ns_Ca :/non_specific_calcium_activated_current:K_m_ns_Ca 0 ]
			[ Cai       :/ionic_concentrations:Cai                         0 ];
	}
	
	Process ExpressionAssignmentProcess( i_ns_Ca )
	{
		Name	__none__;
		Expression	"i_ns_Na.Value + i_ns_K.Value";
		VariableReferenceList
			[ i_ns_Ca :/non_specific_calcium_activated_current:i_ns_Ca 1 ]
			[ i_ns_Na :/non_specific_calcium_activated_current:i_ns_Na 0 ]
			[ i_ns_K  :/non_specific_calcium_activated_current:i_ns_K  0 ];
	}
	
	Process ExpressionAssignmentProcess( I_ns_Na )
	{
		Name	__none__;
		Expression	"P_ns_Ca.Value * pow( 1.0, 2.0 ) * Vns.Value * pow( F.Value, 2.0 ) / ( R.Value * T.Value ) * ( gamma_Nai.Value * Nai.Value * exp( 1.0 * Vns.Value * F.Value / ( R.Value * T.Value ) ) - gamma_Nao.Value * Nao.Value ) / ( exp( 1.0 * Vns.Value * F.Value / ( R.Value * T.Value ) ) - 1.0 )";
		VariableReferenceList
			[ P_ns_Ca   :/non_specific_calcium_activated_current:P_ns_Ca 0 ]
			[ gamma_Nai :/L_type_Ca_channel:gamma_Nai                    0 ]
			[ gamma_Nao :/L_type_Ca_channel:gamma_Nao                    0 ]
			[ R         :/membrane:R                                     0 ]
			[ T         :/membrane:T                                     0 ]
			[ F         :/membrane:F                                     0 ]
			[ Nao       :/ionic_concentrations:Nao                       0 ]
			[ Nai       :/ionic_concentrations:Nai                       0 ]
			[ I_ns_Na   :/non_specific_calcium_activated_current:I_ns_Na 1 ]
			[ Vns       :/non_specific_calcium_activated_current:Vns     0 ];
	}
	
	Process ExpressionAssignmentProcess( I_ns_K )
	{
		Name	__none__;
		Expression	"P_ns_Ca.Value * pow( 1.0, 2.0 ) * Vns.Value * pow( F.Value, 2.0 ) / ( R.Value * T.Value ) * ( gamma_Ki.Value * Ki.Value * exp( 1.0 * Vns.Value * F.Value / ( R.Value * T.Value ) ) - gamma_Ko.Value * Ko.Value ) / ( exp( 1.0 * Vns.Value * F.Value / ( R.Value * T.Value ) ) - 1.0 )";
		VariableReferenceList
			[ P_ns_Ca  :/non_specific_calcium_activated_current:P_ns_Ca 0 ]
			[ gamma_Ki :/L_type_Ca_channel:gamma_Ki                     0 ]
			[ gamma_Ko :/L_type_Ca_channel:gamma_Ko                     0 ]
			[ R        :/membrane:R                                     0 ]
			[ T        :/membrane:T                                     0 ]
			[ F        :/membrane:F                                     0 ]
			[ Ko       :/ionic_concentrations:Ko                        0 ]
			[ Ki       :/ionic_concentrations:Ki                        0 ]
			[ I_ns_K   :/non_specific_calcium_activated_current:I_ns_K  1 ]
			[ Vns      :/non_specific_calcium_activated_current:Vns     0 ];
	}
	
	
}

System System( /time_dependent_potassium_current_Xi_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( Xi )
	{
		Value	0.987737966405;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( Xi )
	{
		Name	__none__;
		Expression	"1.0 / ( 1.0 + exp( ( V.Value - 56.26 ) / 32.1 ) )";
		VariableReferenceList
			[ Xi :/time_dependent_potassium_current_Xi_gate:Xi 1 ]
			[ V  :/membrane:V                                  0 ];
	}
	
	
}

System System( /fast_sodium_current_h_gate )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( alpha_h )
	{
		Value	0.266473493851;
		Name	__none__;
	}
	
	Variable Variable( beta_h )
	{
		Value	0.00444699851649;
		Name	__none__;
	}
	
	Variable Variable( h )
	{
		Value	1.0;
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
		Expression	"piecewise( 0.135 * exp( ( 80.0 + V.Value ) / -6.8 ), lt( V.Value, -40.0 ), 0.0 )";
		VariableReferenceList
			[ alpha_h :/fast_sodium_current_h_gate:alpha_h 1 ]
			[ V       :/membrane:V                         0 ];
	}
	
	Process ExpressionAssignmentProcess( beta_h )
	{
		Name	__none__;
		Expression	"piecewise( 3.56 * exp( 0.079 * V.Value ) + 310000.0 * exp( 0.35 * V.Value ), lt( V.Value, -40.0 ), 1.0 / ( 0.13 * ( 1.0 + exp( ( V.Value + 10.66 ) / -11.1 ) ) ) )";
		VariableReferenceList
			[ beta_h :/fast_sodium_current_h_gate:beta_h 1 ]
			[ V      :/membrane:V                        0 ];
	}
	
	Process ExpressionFluxProcess( h )
	{
		Name	__none__;
		Expression	"alpha_h.Value * ( 1.0 - h.Value ) - beta_h.Value * h.Value";
		VariableReferenceList
			[ h       :/fast_sodium_current_h_gate:h       1 ]
			[ alpha_h :/fast_sodium_current_h_gate:alpha_h 0 ]
			[ beta_h  :/fast_sodium_current_h_gate:beta_h  0 ];
	}
	
	
}

