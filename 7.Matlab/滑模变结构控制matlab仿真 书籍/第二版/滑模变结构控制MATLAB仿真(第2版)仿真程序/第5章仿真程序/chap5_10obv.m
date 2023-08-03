function [sys,x0,str,ts]=s_function(t,x,u,flag)
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
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0;0;0;0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
g=9.8;M=1.0;m=0.1;L=0.5;

I=1/12*m*L^2;  
l=1/2*L;
t1=m*(M+m)*g*l/[(M+m)*I+M*m*l^2];
t2=-m^2*g*l^2/[(m+M)*I+M*m*l^2];
t3=-m*l/[(M+m)*I+M*m*l^2];
t4=(I+m*l^2)/[(m+M)*I+M*m*l^2];

ut=u(1);
th=u(2);
x1=u(3);

y=[th;x1];

A=[0 1 0 0;
   0 0 0 0;
   0 0 0 1;
   0 0 0 0];

B=[0 0;
   1 0;
   0 0;
   0 1];
C=[1 0 0 0;
   0 0 1 0];
Fai = [t1*th+t3*ut;
       t2*th+t4*ut];

k0=1;
alpha1= 2*k0;
alpha2= k0^2;
alpha3= 2*k0;
alpha4= k0^2;

xite=0.10;
L=[alpha1/xite 0;
   alpha2/(xite^2) 0;
   0 alpha3/xite;
   0 alpha4/(xite^2)];
dx=A*x+B*Fai+L*(y-C*x);

sys(1) = dx(1);
sys(2) = dx(2);
sys(3) = dx(3);
sys(4) = dx(4);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);