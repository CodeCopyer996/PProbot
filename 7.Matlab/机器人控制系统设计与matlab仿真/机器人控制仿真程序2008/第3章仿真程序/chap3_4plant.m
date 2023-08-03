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
x0  = [0.15;0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)   %Time-varying model

g=9.8;
m=1;
l=0.25;

D0=4/3*m*l^2;
d_D0=0.2*D0;
D=D0-d_D0;
C0=2.0;
d_C0=0.2*C0;
C=C0-d_C0;
G0=m*g*l*cos(x(1));
d_G0=0.2*G0;
G=G0-d_G0;
d=1.3*sin(0.5*pi*t);

tol=u;

P=2;
sys(1)=x(2);
if P==1
    sys(2)=1/D0*(-C0*x(2)-G0+tol);
elseif P==2
    sys(2)=1/D*(-C*x(2)-G+tol+d);
end

function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);