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

r=sin(3*2*pi*t);
dr=3*2*pi*cos(3*2*pi*t);
ddr=-(3*2*pi)^2*sin(3*2*pi*t);

e=u(1);
de=u(2);
x2=dr-de;

fx=-25*x2;
gx=133;

alfa0=2;
beta0=1;
p0=9;q0=5;
p=3;q=1;

fai=100;
gama=10;

s0=e;
ds0=de;
z0=abs(s0)^(q0/p0)*sign(s0);
s1=ds0+alfa0*s0+beta0*z0;
z1=abs(s1)^(q/p)*sign(s1);

ut=1/gx*(ddr-fx+alfa0*ds0+beta0*q0/p0*z0*ds0+fai*s1+gama*z1);

sys(1)=ut;