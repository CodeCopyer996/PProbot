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
sizes.NumOutputs     = 3;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[];
str=[];
ts=[];

function sys=mdlOutputs(t,x,u)
persistent s0

e=u(1);
de=u(2);

c=150;
if t==0
   e0=e;de0=de;
	s0=c*e0+de0;
end

r=1*sin(0.5*2*pi*t);
dr=1*2*pi*0.5*cos(0.5*2*pi*t);
ddr=-1*(2*pi*0.5)^2*sin(0.5*2*pi*t);
%r=1.0;dr=0;ddr=0;

x1=r-e;
x2=dr-de;

fx=-25*x2;
b=133;

nmn=10;
Ft=s0*exp(-nmn*t);
dFt=-s0*nmn*exp(-nmn*t);

s=c*e+de-Ft;

D=250;
xite=1.0;

M=2;
if M==1
   K=D+xite;
elseif M==2    %Estimation for K with fuzzy
   K=abs(u(3))+xite;
end

ut=1/b*(-fx+ddr+c*de+K*sign(s)-dFt);
%ut=50*e+0.01*de;

sys(1)=ut;
sys(2)=s;
sys(3)=K;