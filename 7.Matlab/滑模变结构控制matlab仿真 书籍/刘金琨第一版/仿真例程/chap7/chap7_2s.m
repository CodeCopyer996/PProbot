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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];

function sys=mdlOutputs(t,x,u)
x1=u(1);
dx1=u(2);
ddx1=u(3);
ut=u(4);

r=sin(0.2*t)+0.5*cos(t);
dr=0.2*cos(0.2*t)-0.5*sin(t);
ddr=-0.2^2*sin(0.2*t)-0.5*cos(t);
dddr=-0.2^3*cos(0.2*t)+0.5*sin(t);

e=x1-r;
de=dx1-dr;
dde=ddx1-ddr;

c=5;
s=c*e+de;

fx=-25*dx1;
df=-25*ddx1;

gx=133;
nmn=15;

Dmax=1.5;
dDmax=1.5;
ec=(c+nmn)*Dmax+dDmax+2.0;

ds=c*de+dde;
rou=ds+nmn*s;
du=1/gx*[-(c+nmn)*133*ut-(c+nmn)*fx-df+(c+nmn)*ddr+dddr-nmn*c*de-ec*sign(rou)];

sys(1)=r;
sys(2)=du;