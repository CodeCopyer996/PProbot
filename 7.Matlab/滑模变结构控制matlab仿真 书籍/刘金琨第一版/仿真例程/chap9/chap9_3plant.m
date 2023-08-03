%S-function for continuous state equation
function [sys,x0,str,ts]=s_function(t,x,u,flag)

switch flag,
%Initialization
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 1,
    sys=mdlDerivatives(t,x,u);
%Outputs
  case 3,
    sys=mdlOutputs(t,x,u);
%Unhandled flags
  case {2, 4, 9 },
    sys = [];
%Unexpected flags
  otherwise
    error(['Unhandled flag =',num2str(flag)]);
  end

%mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[0.6,0];
str=[];
ts=[];

function sys=mdlDerivatives(t,x,u)
	fx=(10+0.01*sin(t))*x(1);
	bx=130+0.1*cos(t);

	dfx=0.01*cos(t)*x(1)+(10+0.01*sin(t))*x(2);
	dbx=-0.1*sin(t);
	dt=3.9+0.1*sin(t/2);
sys(1)=x(2);
sys(2)=fx+bx*u+dt;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);