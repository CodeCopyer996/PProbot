%S-function for continuous state equation
function [sys,x0,str,ts]=s_function(t,x,u,flag)

switch flag,
%Initialization
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[];
str=[];
ts=[];

function sys=mdlOutputs(t,x,u)
error=u(1);
derror=u(2);

c1=100;c2=100;n1=5;

r=0.5*sin(3*2*pi*t);
dr=0.5*3*2*pi*cos(3*2*pi*t);
ddr=-0.5*(3*2*pi)^2*sin(3*2*pi*t);

e1=u(1);
de=u(2);
z1=u(3);

x2=dr-de;
w=x2;

wr=c1*e1+dr+n1*z1;

e2=wr-w;

J=1/133;
b=25/133;
ut=J*[(1-c1^2+n1)*e1+(c1+c2)*e2-c1*n1*z1+ddr]+b*x2;
 
sys(1)=ut;