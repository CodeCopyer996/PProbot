function [sys,x0,str,ts] = spacemodel(t,x,u,flag)  %From chap13_2plant.m in PID Book
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [-10/57.3,0,0.20,0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
%Single Link Inverted Pendulum Parameters
g=9.8;M=1.0;m=0.1;L=0.5;

I=1/12*m*L^2;  
l=1/2*L;
t1=m*(M+m)*g*l/[(M+m)*I+M*m*l^2];
t2=-m^2*g*l^2/[(m+M)*I+M*m*l^2];
t3=-m*l/[(M+m)*I+M*m*l^2];
t4=(I+m*l^2)/[(m+M)*I+M*m*l^2];

A=[0,1,0,0;
   t1,0,0,0;
   0,0,0,1;
   t2,0,0,0];
B=[0;t3;0;t4];
C=[1,0,0,0;
   0,0,1,0];

v=u(1);
sys(1)=x(2);
sys(2)=t1*x(1)+t3*v;    %ddth
sys(3)=x(4);
sys(4)=t2*x(1)+t4*v;    %ddx
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);   %th
sys(2)=x(2);
sys(3)=x(3);   %x
sys(4)=x(4);