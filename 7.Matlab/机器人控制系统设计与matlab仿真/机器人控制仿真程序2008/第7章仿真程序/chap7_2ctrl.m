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
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[];
str=[];
ts=[];

function sys=mdlOutputs(t,x,u)
r=sin(2*pi*t);
dr=2*pi*cos(2*pi*t);
ddr=-(2*pi)^2*sin(2*pi*t);

e=u(1);
de=u(2);

c=25;
s=c*e+de;

M=1/133;
x2=dr-de;
H=25/133*x2;

fU0=200/133;
fL0=0;

fU=200;
fL=0;

fm=(fU-fL)/2;
fp=(fU+fL)/2;

eq=0.5;
k=5;
ut=M*(c*de+ddr+eq*sign(s)+k*s)+H-M*(fp-fm*sign(s));

sys(1)=ut;