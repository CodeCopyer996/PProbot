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
  case {2, 4, 9 }
    sys = [];
%Unexpected flags
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

%mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[0.5,0.5,0];
str=[];
ts=[];

function sys=mdlDerivatives(t,x,u)

%Friction
	Fc=0.28*1000;
	Fs=0.34*1000;
	vs=0.01;
   af=0.02;
   rou0=260;
   rou1=2.5;
	g=Fc+(Fs-Fc)*exp(-(x(2)/vs)^2)+af*x(2);
	sys(3)=x(2)-(rou0*abs(x(2))/g)*x(3);   %?????
	dt=rou0*x(3)+rou1*sys(3)+af*x(2);

sys(1)=x(2);
sys(2)=-25*x(2)+133*u-dt; 
function sys=mdlOutputs(t,x,u)

%Friction
	Fc=0.28*1000;
	Fs=0.34*1000;
	vs=0.01;
   af=0.02;
   rou0=260;
   rou1=2.5;
	g=Fc+(Fs-Fc)*exp(-(x(2)/vs)^2)+af*x(2);
	Q=x(2)-(rou0*abs(x(2))/g)*x(3);   %?????
	dt=rou0*x(3)+rou1*Q+af*x(2);

sys(1)=x(1);
sys(2)=dt;