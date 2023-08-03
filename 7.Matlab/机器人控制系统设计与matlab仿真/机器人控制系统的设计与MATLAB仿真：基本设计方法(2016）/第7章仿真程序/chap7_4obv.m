function [sys,x0,str,ts]= NDO(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
tol=[u(1);u(2)];
th=[u(3);u(5)];
dth=[u(4);u(6)];

g=9.8;
j1=0.1;j2=0;j3=0.01;X=0.01;
J=[j1+2*X*cos(th(2)) j2+X*cos(th(2))
   j2+X*cos(th(2)) j3];
G1=0.01*g*cos(th(1)+th(2));
G2=0.01*g*cos(th(1)+th(2));
G=[G1;G2];

X=[0.2837  0;
   0    0.3503];

z=[x(1) x(2)]';
L=inv(X)*inv(J);
p=inv(X)*dth;
dp=z+p;

dz=L*(G-tol-dp);
sys(1)=dz(1);
sys(2)=dz(2);
function sys=mdlOutputs(t,x,u)
tol=[u(1);u(2)];
th=[u(3);u(5)];
dth=[u(4);u(6)];

g=9.8;
j1=0.1;j2=0;j3=0.01;X=0.01;
J=[j1+2*X*cos(th(2)) j2+X*cos(th(2))
   j2+X*cos(th(2)) j3];
G1=0.01*g*cos(th(1)+th(2));
G2=0.01*g*cos(th(1)+th(2));
G=[G1;G2];

X=[0.2837  0;
   0    0.3503];

z=[x(1) x(2)]';
L=inv(X)*inv(J);
p=inv(X)*dth;
dp=z+p;

sys(1)=dp(1);
sys(2)=dp(2);