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
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
Jl=0.3575;Jd=0.000425;
gr=4;c1=0.004;c2=0.05;k=8.45;

k1=10;k2=10;k3=10;

th2d=u(1);
dth2d=cos(t);
ddth2d=-sin(t);
dddth2d=-cos(t);
ddddth2d=sin(t);

th1=u(2);dth1=u(3);
th2=u(4);dth2=u(5);
ddth2=-1/Jl*(c2*dth2+k*(th2-1/gr*th1));
dddth2=-1/Jl*(c2*ddth2+k*(dth2-1/gr*dth1));

e=th2d-th2;
de=dth2d-dth2;
dde=ddth2d-ddth2;
ddde=dddth2d-dddth2;

nmn=3;
r=de+nmn*e;
dr=dde+nmn*de;
ddr=ddde+nmn*dde;

F1=-c2*dth2-k*(th2-1/gr*th1);
dF1=-c2/Jl*F1-k*(dth2-1/gr*dth1);

z2=Jl*ddth2d-F1+Jl*nmn*de+k1*r;
dz2=Jl*dddth2d-dF1+Jl*nmn*dde+k1*dr;

z3=Jl*dddth2d-dF1+Jl*nmn*dde+k1*dr+k2*z2+r;

ddF1=Jl*ddddth2d+Jl*nmn*ddde+k1*ddr+k2*dz2+dr+z2+k3*z3;
F3=c1*dth1+k*1/gr*(1/gr*th1-th2);

ut=gr*Jd/k*(k/Jl*F1+c2/Jl*dF1+ddF1)+F3;

sys(1)=ut;