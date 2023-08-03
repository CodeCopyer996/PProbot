function [sys,x0,str,ts] = spacemodel(t,x,u,flag)

switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
tol=u(1);

x1=u(2);
x2=u(3);
dx1=u(4);
dx2=u(5);

qd=sin(2*pi*t);
dqd=2*pi*cos(2*pi*t);
ddqd=-(2*pi)^2*sin(2*pi*t);
dddqd=-(2*pi)^3*cos(2*pi*t);
e=x1-qd;
de=x2-dqd;
dde=dx2-ddqd;

n1=30;n2=50;n=25;
s=dde+n1*de+n2*e;

M=0.1+0.06*sin(x1);
dM=0.06*cos(x1);
C=0.03*cos(x1);
dC=-0.03*sin(x1);
m=0.020;
g=9.8;
l=0.05;
G=m*g*l*cos(x1);
dG=-m*g*l*sin(x1);

H=M*(n1*dde+n2*de-dddqd)+C*(n1*de+n2*e-ddqd)-(dM+n*M)*dx2-(dC+n*C)*x2-(dG+n*G);

xite=50;
ut=-1/n*(H+xite*sign(s));
sys(1)=ut;