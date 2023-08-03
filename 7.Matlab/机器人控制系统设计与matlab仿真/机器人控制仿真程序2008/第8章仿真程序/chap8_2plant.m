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
alfa0=0.10;alfa1=0.10;
beta0=12+2*sin(pi*t);
beta1=1.0*sin(pi*t);

ut=u(1);
speed=x(2);
Fs=1.0*sign(speed);
Fc=0.5*exp(-3.6*abs(speed))*sign(speed);
Dv=0.02;
if abs(speed)>Dv
    nmna=1;
else
    nmna=0;
end
F=nmna*Fc+(1-nmna)*Fs;
sys(1)=x(2);
sys(2)=beta0*ut-beta1*F-alfa1*x(2)-alfa0*x(1);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);