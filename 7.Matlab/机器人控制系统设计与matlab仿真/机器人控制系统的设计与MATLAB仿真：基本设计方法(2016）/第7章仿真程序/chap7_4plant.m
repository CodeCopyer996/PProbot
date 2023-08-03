function [sys,x0,str,ts]= NDO_plant (t,x,u,flag)
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
global k1 k2
k1=0.2;k2=0.2;
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.1,0,0.1,0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
global k1 k2 
tol=[u(1);u(2)];
g=9.8;
j1=0.1;j2=0;j3=0.01;
Xp=0.01;

J=[j1+2*Xp*cos(x(3)) j2+Xp*cos(x(3))
   j2+Xp*cos(x(3)) j3];

G1=0.01*g*cos(x(1)+x(3));
G2=0.01*g*cos(x(1)+x(3));
G=[G1;G2];

dt=[k1*x(2);k2*x(4)];

S=inv(J)*(tol+dt-G);
sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
global k1 k2 
dt=[k1*x(2);k2*x(4)];

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);
sys(5)=dt(1);
sys(6)=dt(2);