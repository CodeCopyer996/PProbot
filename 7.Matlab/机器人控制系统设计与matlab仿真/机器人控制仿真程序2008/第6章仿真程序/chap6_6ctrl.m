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
sizes.NumInputs      = 7;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
Jl=0.3575;Jd=0.000425;
gr=4;
c1=0.004;c2=0.05;
k=8.45;

k1=3.0;k2=3.0;k3=2.0;
nmn=5.5;

q2d=u(1);
dq2d=pi*cos(pi*t);
ddq2d=-pi^2*sin(pi*t);
dddq2d=-pi^3*cos(pi*t);
ddddq2d=pi^4*sin(pi*t);

q1=u(2);dq1=u(3);
q2=u(4);dq2=u(5);
ddq2=u(6);
dddq2=u(7);

e=q2d-q2;
de=dq2d-dq2;
dde=ddq2d-ddq2;
ddde=dddq2d-dddq2;

r=de+nmn*e;
dr=dde+nmn*de;
ddr=ddde+nmn*dde;

F1=Jl*(ddq2d+nmn*de)+c2*(dq2d+nmn*e);
dF1=Jl*(dddq2d+nmn*dde)+c2*(ddq2d+nmn*de);
ddF1=Jl*(ddddq2d+nmn*ddde)+c2*(dddq2d+nmn*dde);

zd=-1/k*(F1+k1*r);
dzd=-1/k*(dF1+k1*dr);
ddzd=-1/k*(ddF1+k1*ddr);

z=q2-1/gr*q1;
dz=dq2-1/gr*dq1;

F2=dzd;
dF2=ddzd;

xite1=zd-z;
dxite1=dzd-dz;

u1=F2+k2*xite1-k*r;
du1=dF2+k2*dxite1-k*dr;

xite2=u1-dz;

F3=Jd*gr*du1-Jd*gr*ddq2-c1*dq1+k*1/gr*z;

Td=-F3-k3*xite2-xite1;

sys(1)=Td;