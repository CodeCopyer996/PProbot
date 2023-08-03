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
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[1 0 1 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
l1=0.25;l2=0.25;
P=[1.66 0.42 0.63 3.75 1.25];
g=9.8;
L=[l1^2 l2^2 l1*l2 l1 l2];
pl=0.5;
M=P+pl*L;

q1=x(1);dq1=x(1);
q2=x(3);dq2=x(4);
dq=[dq1 dq2]';

D=[M(1)+M(2)+2*M(3)*cos(q2) M(2)+M(3)*cos(q2);
    M(2)+M(3)*cos(q2) M(2)];
C=[-M(3)*dq2*sin(q2) -M(3)*(dq1+dq2)*sin(q2);
    M(3)*dq1*sin(q2)  0];
G=[M(4)*g*cos(q1)+M(5)*g*cos(q1+q2);
   M(5)*g*cos(q1+q2)];

tol=[u(1) u(2)]';
S=inv(D)*(tol-C*dq-G);

sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);