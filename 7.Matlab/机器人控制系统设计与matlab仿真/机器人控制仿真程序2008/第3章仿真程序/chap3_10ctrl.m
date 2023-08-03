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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
qd=u(1);
dqd=0.5*2*cos(2*t);
ddqd=-0.5*2*sin(2*t);

x(1)=u(2);
x(2)=u(3);

e=qd-x(1);
de=dqd-x(2);

Fai=10;
Kv=20;

r=de+Fai*e;
%%%%%%%%%%%%%%%%%%%%%%%%
g=9.8;
m=1;
l=0.25;

M=4/3*m*l^2;
Vm=2.0;
G=m*g*l*cos(x(1));
F=1.3*sin(0.5*pi*t);
%%%%%%%%%%%%%%%%%%%%%%%%
fx=M*(ddqd+Fai*de)+Vm*(dqd+Fai*e)+G+F;
fxp=1.0*fx;
v=0*sign(r);
w=fxp+Kv*r+v;

sys(1)=w;
sys(2)=r;