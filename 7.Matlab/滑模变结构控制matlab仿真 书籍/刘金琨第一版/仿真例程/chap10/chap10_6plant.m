function [sys,x0,str,ts] = spacemodel(t,x,u,flag)

switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
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
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = [0.5;0];
str = [];
ts = [0 0];

function sys=mdlDerivatives(t,x,u)
E=0.1*sin(2*pi*t);

A=[0 1;0 -25];
B=[0;133];

ut=u(1);
sys(1)=x(2);
sys(2)=A(2,2)*x(2)+B(2)*(ut+E);

function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);