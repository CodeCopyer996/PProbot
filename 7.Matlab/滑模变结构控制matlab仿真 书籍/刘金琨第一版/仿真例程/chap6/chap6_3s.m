function [sys,x0,str,ts] = controller(t,x,u,flag)

switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9},
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];

function sys=mdlOutputs(t,x,u)
c1=70;
k1=50;
h=20;
gama=30;
beta=1.5;
Fmax=2;

Am=-25;
Bm=133;

Yd=u(1);
dYd=2*pi*cos(2*pi*t);
ddYd=-(2*pi)^2*sin(2*pi*t);

Y=u(2);
Xp=u(3);
Fp=u(4);

z1=Y-Yd;
dz1=Xp-dYd;
alfa1=c1*z1;
d_alfa1=c1*dz1;

z2=Xp-dYd+alfa1;

rou=k1*z1+z2;

ut=1/Bm*(-k1*(z2-c1*z1)-Am*(z2+dYd-alfa1)+...
   -Fp+ddYd-d_alfa1-h*(rou+beta*sign(rou)));

sys(1)=ut;
sys(2)=gama*rou;