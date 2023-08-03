function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
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
x0=[0;0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
m=0.1183;M=0.1447;
n=1.1623;N=1.4207;

a=m+(M-m)*abs(sin(t));
b=n+(N-n)*abs(sin(t));

gamas=0.05;gamaf=0.3;

v=x(2);
nius=gamas*sign(v);
niuf=gamaf*exp(-3.6*abs(v))*sign(v);

eta=0.50;
if abs(v)>eta
    nmn=1;
else
    nmn=0;
end
f=nius*nmn+niuf*(1-nmn);
sys(1)=x(2);
sys(2)=u(1)-f-b*x(2)-a*x(1);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);