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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[0.5,0.5];
str=[];
ts=[];

function sys=mdlDerivatives(t,x,u)

%bi=0.05;ci=5;
bi=0.5;ci=5;
dt=200*exp(-(t-ci)^2/(2*bi^2));   %rbf_func.m
%dt=0;

sys(1)=x(2);
sys(2)=-25*x(2)+133*u+dt; 
function sys=mdlOutputs(t,x,u)
%bi=0.05;ci=5;
bi=0.5;ci=5;
dt=200*exp(-(t-ci)^2/(2*bi^2));   %rbf_func.m
%dt=0;

sys(1)=x(1);
sys(2)=dt;