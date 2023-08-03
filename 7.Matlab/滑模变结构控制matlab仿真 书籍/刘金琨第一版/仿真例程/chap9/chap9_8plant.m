%S-function for continuous state equation
function [sys,x0,str,ts]=s_function(t,x,u,flag)

switch flag,
%Initialization
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
%Outputs
  case 3,
    sys=mdlOutputs(t,x,u);
%Unhandled flags
  case {2, 4, 9 }
    sys = [];
%Unexpected flags
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

%mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[1.0,0,1.5,0];
str=[];
ts=[];

function sys=mdlDerivatives(t,x,u)

r1=1;r2=0.8;
J1=5;J2=5;
m1=0.5;m2=1.5;
g=9.8;

a11=(m1+m2)*r1^2+m2*r2^2+2*m2*r1*r2*cos(x(3))+J1;
a12=m2*r1^2+m2*r1*r2*cos(x(3));
a22=m2*r2^2+J2;
b12=m2*r1*r2*sin(x(3));

gama1=((m1+m2)*r1*cos(x(3))+m2*r2*cos(x(1)+x(3)));
gama2=m2*r2*cos(x(1)+x(3));

M0=[a11 a12;a12 a22];
C0=[-b12*x(2)*x(2)-2*b12*x(2)*x(4);b12*x(4)*x(4)];
g0=[gama1*g;gama2*g];

tao=u(1:2);

q=[x(1);x(3)];
dq=[x(2);x(4)];
rou=0.1+0.2*q+0.3*dq'*dq;

Y=inv(M0)*(tao+rou-C0-g0);

sys(1)=x(2);
sys(2)=Y(1);
sys(3)=x(4);
sys(4)=Y(2);

function sys=mdlOutputs(t,x,u)

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);