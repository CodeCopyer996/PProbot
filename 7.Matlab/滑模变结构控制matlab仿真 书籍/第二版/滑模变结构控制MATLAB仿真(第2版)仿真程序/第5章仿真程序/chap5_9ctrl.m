function [sys,x0,str,ts] = controller(t,x,u,flag)
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
I=1.0;J=1.0;Mgl=5.0;K=40;
a1=K/I;a2=1/J;

xd=u(1);
dxd=cos(t);
ddxd=-sin(t);
dddxd=-cos(t);
ddddxd=sin(t);

x1p=u(2);
x2p=u(3);
x3p=u(4);
x4p=u(5);

f1p=-1/I*Mgl*sin(x1p)-K/I*x1p;

dx2p=a1*x3p+f1p;

df1p=-1/I*Mgl*cos(x1p)*x2p-K/I*x2p;
ddf1p=-1/I*Mgl*(-sin(x1p)*x2p^2+cos(x1p)*dx2p)-K/I*dx2p;
f2p=1/J*K*(x1p-x3p);

c1=1000;c2=300;c3=30;
e1p=x1p-xd;
e2p=x2p-dxd;
e3p=a1*x3p+f1p-ddxd;
e4p=a1*x4p+df1p-dddxd;

sp=c1*e1p+c2*e2p+c3*e3p+e4p;

xite=1.50;
ut=-1/(a1*a2)*(c1*(x2p-dxd)+c2*(a1*x3p+f1p-ddxd)+c3*(a1*x4p+df1p-dddxd)+a1*f2p+ddf1p-ddddxd+xite*sp);

sys(1)=ut;