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
global M V x0 fai

sizes = simsizes;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0=[];
str = [];
ts = [0 0];
function sys=mdlOutputs(t,x,u)
c1=35;
c2=15;

zd=u(1);
dzd=6*pi*cos(6*pi*t);
ddzd=-(6*pi)^2*sin(6*pi*t);
x1=u(2);
x2=u(3);

f=-25*x2;
b=133;

z1=x1-zd;
dz1=x2-dzd;

alfa1=-c1*z1+dzd;
z2=x2-alfa1;
ut=(1/b)*(-f-c2*z2-z1-c1*dz1+ddzd);

sys(1)=ut;