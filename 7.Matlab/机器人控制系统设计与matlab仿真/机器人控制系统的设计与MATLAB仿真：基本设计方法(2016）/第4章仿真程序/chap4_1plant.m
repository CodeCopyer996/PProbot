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

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[0.15 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)   %Ref to PID411
g=9.8;
m=1;
l=0.25;
d=2.0;
I=4/3*m*l^2;

tol=u;
k1=0.30;
k2=1.5;
told=sign(x(2))*(k1*abs(x(2))+k2);

fx=1/I*(-d*x(2)-m*g*l*cos(x(1)));
gx=1/I;

sys(1)=x(2);
sys(2)=fx+gx*(tol-told);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);