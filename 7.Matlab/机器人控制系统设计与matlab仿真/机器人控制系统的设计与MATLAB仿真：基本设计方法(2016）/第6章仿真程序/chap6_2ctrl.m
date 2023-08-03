function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
B=0.015;L=0.0008;D=0.05;R=0.075;m=0.01;J=0.05;
l=0.6;Kb=0.085;M=0.05;Kt=1;g=9.8;
Mt=J+1/3*m*l^2+1/10*M*l^2*D;
N=m*g*l+M*g*l;

zd=u(1);
dzd=cos(t);
ddzd=-sin(t);
dddzd=-cos(t);

x1=u(2);
x2=u(3);
x3=u(4);
fx=x1^2+x2^2;

z1=x1-zd;
c1=15;c2=15;c3=15;

a1=-B/Mt;a2=N/Mt*fx;a3=Kt/Mt;
b1=-R/L;b2=-Kb/L;b3=1/L;

dx2=a1*x2+a2+a3*x3;
dfx=2*x1*x2+2*x2*dx2;

da2=N/Mt*dfx;
dz1=x2-dzd;
ddz1=dx2-ddzd;
z2=x2+c1*z1-dzd;
dz2=dx2+c1*dz1-ddzd;
z3=a3*x3+a1*x2+a2+c1*dz1-dddzd+c2*z2+z1;

T=-a1*dx2-da2-c1*ddz1+ddzd-c2*dz2-dz1-z2-c3*z3;
ut=L*(1/a3*T-b1*x3-b2*x2);

sys(1)=ut;