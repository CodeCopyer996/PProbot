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
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0 = [pi/6;0];
str = [];
ts = [];

function sys=mdlDerivatives(t,x,u)
a=25+5*sin(t);
b=133+10*sin(t);
dt=0.10*sin(2*pi*t);

sys(1)=x(2);
sys(2)=-a*x(2)+b*(u+dt);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);