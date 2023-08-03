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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[];
str=[];
ts=[];

function sys=mdlOutputs(t,x,u)
persistent s0

Bn=25/133;
Jn=1/133;
lamt=Bn/Jn;

Jm=1/163;JM=1/103;
Bm=15/163;BM=35/103;

dM=1.0;
K=20; 

e=u(1);  
de=u(2); 
nu=u(3);
v=u(4);

s1=de+lamt*e;

if t==0
   e0=e;de0=de;
	s0=de0+lamt*e0;
end

temp0=(1/Jn)*nu-lamt*v;
  
Ja=1/2*(JM+Jm);
Ba=1/2*(BM+Bm);
  
xite=10;
ft=s0*exp(-xite*t);
s=s1-ft;

H=dM+1/2*(JM-Jm)*abs(temp0)+1/2*(BM-Bm)*abs(v)+JM*xite*abs(s0)*exp(-xite*t);

ut=-K*s-H*sign(s)+Ja*((1/Jn)*nu-lamt*v)+Ba*v;

sys(1)=ut;
sys(2)=s;