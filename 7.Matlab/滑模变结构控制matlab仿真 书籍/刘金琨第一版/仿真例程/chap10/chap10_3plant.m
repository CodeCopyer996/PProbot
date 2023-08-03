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
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1; % At least one sample time is needed
sys = simsizes(sizes);
x0  = [0.5;0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)   %Time-varying model
tol=u(1);
M=0.1+0.06*sin(x(1));
C=0.03*cos(x(1));
m=0.020;
g=9.8;
l=0.05;
G=m*g*l*cos(x(1));
dt=3.0*sin(2*pi*t);

sys(1)=x(2);
sys(2)=1/M*(-C*x(2)-G+tol)+dt;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);