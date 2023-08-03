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
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[0,0];
str=[];
ts=[];

function sys=mdlDerivatives(t,x,u)
c1=2;
th1=x(1);
s=c1*u(2)+u(1)+x(1)*u(2)^2;

sys(1)=u(2)^3;
sys(2)=s*u(2)^2*(c1+2*th1*u(2));
function sys=mdlOutputs(t,x,u)
k=0.5;
c1=2;

th1=x(1);
th2=x(2);
s=c1*u(2)+u(1)+th1*u(2)^2;

sys(1)=-(c1+2*th1*u(2))*u(1)-u(2)^5-th2*(c1+2*th1*u(2))*u(2)^2-u(2)-k*sign(s);