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
sizes.NumOutputs     = 3;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.5;0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u) 
tol=u(1);
D0=0.1+0.06*sin(x(1));
C0=0.03*cos(x(1));
m=0.020;
g=9.8;
l=0.05;
G0=m*g*l*cos(x(1));

sys(1)=x(2);
sys(2)=1/D0*(-C0*x(2)-G0+tol);
function sys=mdlOutputs(t,x,u)    %PID book: page 416
D0=0.1+0.06*sin(x(1));
C0=0.03*cos(x(1));
m=0.020;
g=9.8;
l=0.05;
G0=m*g*l*cos(x(1));

Dm=norm(D0);
Cm=norm(C0);
Gm=norm(G0);

sys(1)=x(1);
sys(2)=x(2);
sys(3)=Cm;