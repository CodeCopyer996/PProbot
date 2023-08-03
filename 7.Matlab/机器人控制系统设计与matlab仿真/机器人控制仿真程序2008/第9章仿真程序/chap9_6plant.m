function [sys,x0,str,ts]=obser(t,x,u,flag)
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
x0=[0 0.5];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
M = 0.5;
g = 9.8;
l = 1;
m = 1;
ut=u(1);

sys(1) = x(2);
sys(2) = (ut-m*g*l*sin(x(1))/2)/M;
function sys=mdlOutputs(t,x,u)
sys(1) = x(1);
sys(2) = x(2);