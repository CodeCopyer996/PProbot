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
sizes.NumOutputs     = 3;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[0.5 0 0];
str=[];
ts=[];

function sys=mdlDerivatives(t,x,u)

B=0.015;L=0.0008;D=0.05;R=0.075;m=0.01;J=0.05;l=0.6;Kb=0.085;M=0.05;Kt=1;g=9.8;

Mt=J+1/3*m*l^2+1/10*M*l^2*D;
N=m*g*l+M*g*l;

fx=sin(x(1));
w=4*sin(t);

sys(1)=x(2);
sys(2)=-B/Mt*x(2)+N/Mt*fx+Kt/Mt*x(3);
sys(3)=-R/L*x(3)-Kb/L*x(2)+1/L*u-1/L*w;

function sys=mdlOutputs(t,x,u)

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);