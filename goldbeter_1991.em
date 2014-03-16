
# created by eml2em program
# from file: goldbeter_1991.eml, date: Sun Mar 16 14:59:59 2014
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

System System( /C )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( C )
	{
		Value	0.01;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionFluxProcess( C )
	{
		Name	__none__;
		Expression	"vi.Value - vd.Value * X.Value * C.Value / ( Kd.Value + C.Value ) - kd.Value * C.Value";
		VariableReferenceList
			[ C  :/C:C                 1 ]
			[ X  :/X:X                 0 ]
			[ kd :/model_parameters:kd 0 ]
			[ Kd :/model_parameters:Kd 0 ]
			[ vi :/model_parameters:vi 0 ]
			[ vd :/model_parameters:vd 0 ];
	}
	
	
}

System System( /M )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( M )
	{
		Value	0.01;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionFluxProcess( M )
	{
		Name	__none__;
		Expression	"V1.Value * M_star.Value / ( K1.Value + M_star.Value ) - V2.Value * M.Value / ( K2.Value + M.Value )";
		VariableReferenceList
			[ M      :/M:M                 1 ]
			[ M_star :/M_star:M_star       0 ]
			[ V1     :/model_parameters:V1 0 ]
			[ V2     :/model_parameters:V2 0 ]
			[ K1     :/model_parameters:K1 0 ]
			[ K2     :/model_parameters:K2 0 ];
	}
	
	
}

System System( /environment )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( time )
	{
		Value	__UNDEFINED__;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	
}

System System( /model_parameters )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( Kc )
	{
		Value	0.5;
		Name	__none__;
	}
	
	Variable Variable( VM1 )
	{
		Value	3;
		Name	__none__;
	}
	
	Variable Variable( VM3 )
	{
		Value	1;
		Name	__none__;
	}
	
	Variable Variable( kd )
	{
		Value	0.01;
		Name	__none__;
	}
	
	Variable Variable( Kd )
	{
		Value	0.02;
		Name	__none__;
	}
	
	Variable Variable( vi )
	{
		Value	0.025;
		Name	__none__;
	}
	
	Variable Variable( vd )
	{
		Value	0.25;
		Name	__none__;
	}
	
	Variable Variable( V1 )
	{
		Value	__UNDEFINED__;
		Name	__none__;
	}
	
	Variable Variable( V2 )
	{
		Value	1.5;
		Name	__none__;
	}
	
	Variable Variable( K1 )
	{
		Value	0.005;
		Name	__none__;
	}
	
	Variable Variable( K2 )
	{
		Value	0.005;
		Name	__none__;
	}
	
	Variable Variable( V3 )
	{
		Value	__UNDEFINED__;
		Name	__none__;
	}
	
	Variable Variable( V4 )
	{
		Value	0.5;
		Name	__none__;
	}
	
	Variable Variable( K3 )
	{
		Value	0.005;
		Name	__none__;
	}
	
	Variable Variable( K4 )
	{
		Value	0.005;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( V1 )
	{
		Name	__none__;
		Expression	"VM1.Value * C.Value / ( Kc.Value + C.Value )";
		VariableReferenceList
			[ Kc  :/model_parameters:Kc  0 ]
			[ V1  :/model_parameters:V1  1 ]
			[ VM1 :/model_parameters:VM1 0 ]
			[ C   :/C:C                  0 ];
	}
	
	Process ExpressionAssignmentProcess( V3 )
	{
		Name	__none__;
		Expression	"M.Value * VM3.Value";
		VariableReferenceList
			[ V3  :/model_parameters:V3  1 ]
			[ VM3 :/model_parameters:VM3 0 ]
			[ M   :/M:M                  0 ];
	}
	
	
}

System System( /X )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( X )
	{
		Value	0.01;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionFluxProcess( X )
	{
		Name	__none__;
		Expression	"V3.Value * X_star.Value / ( K3.Value + X_star.Value ) - V4.Value * X.Value / ( K4.Value + X.Value )";
		VariableReferenceList
			[ X      :/X:X                 1 ]
			[ X_star :/X_star:X_star       0 ]
			[ V3     :/model_parameters:V3 0 ]
			[ V4     :/model_parameters:V4 0 ]
			[ K3     :/model_parameters:K3 0 ]
			[ K4     :/model_parameters:K4 0 ];
	}
	
	
}

System System( /X_star )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( X_star )
	{
		Value	__UNDEFINED__;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( X_star )
	{
		Name	__none__;
		Expression	"1 - X.Value";
		VariableReferenceList
			[ X_star :/X_star:X_star 1 ]
			[ X      :/X:X           0 ];
	}
	
	
}

System System( /M_star )
{
	Name	__none__;
	StepperID	ODE;

	Variable Variable( M_star )
	{
		Value	__UNDEFINED__;
		Name	__none__;
	}
	
	Variable Variable( SIZE )
	{
		Value	1.0;
		Name	__none__;
	}
	
	Process ExpressionAssignmentProcess( M_star )
	{
		Name	__none__;
		Expression	"1 - M.Value";
		VariableReferenceList
			[ M_star :/M_star:M_star 1 ]
			[ M      :/M:M           0 ];
	}
	
	
}

