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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[-0.15 -0.15];
str=[];
ts=[];

function sys=mdlDerivatives(t,x,u)
a=5.0;
dt=10*sin(t);

r=sin(2*pi*t);    
dr=2*pi*cos(2*pi*t);
ddr=-(2*pi)^2*sin(2*pi*t);

x1=r-x(1);
x2=dr-x(2);

fx=3*x2;
df=3*sin(t);
sys(1)=x(2);
sys(2)=ddr-fx-df-a*u-dt; 

function sys=mdlOutputs(t,x,u)

sys(1)=x(1);