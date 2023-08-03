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
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[pi/6,0,0,0];
str=[];
ts=[];

function sys=mdlDerivatives(t,x,u)
b=100;
f=8.5+0.5*sin(2*pi*t);

K1=15000;
K2=50;

sys(1)=x(2);
sys(2)=-b*x(2)-u+f;
sys(3)=K1*(x(2)-x(4));
sys(4)=x(3)-b*x(4)-u+K2*(x(2)-x(4));

function sys=mdlOutputs(t,x,u)
f=8.5+0.5*sin(2*pi*t);

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=f;