function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
qd1=u(1);
q1=u(2);
dq1=u(3);
q2=u(4);
dq2=u(5);

dqd1=-0.5*sin(t);
ddqd1=-0.5*cos(t);

l1=1;l2=1;
p=[2.9 0.76 0.87 3.04 0.87];
g=9.8;
 
D=[p(1)+p(2)+2*p(3)*cos(q2) p(2)+p(3)*cos(q2);
    p(2)+p(3)*cos(q2) p(2)];
C=[-p(3)*dq2*sin(q2) -p(3)*(dq1+dq2)*sin(q2);
     p(3)*dq1*sin(q2)  0];
G=[p(4)*g*cos(q1)+p(5)*g*cos(q1+q2);
    p(5)*g*cos(q1+q2)];

J=[-l1*sin(q1)-l2*sin(q1+q2) -l2*sin(q1+q2)];

L=[1 -2]';

D1=D*L;
C1=C*L;
G1=G;

e1=qd1-q1;
de1=dqd1-dq1;

Fai=5.0;
dqr1=dqd1+Fai*e1;
ddqr1=ddqd1+Fai*de1;
r1=de1+Fai*e1;

lambda=u(6);
lambda_d=10*sin(t);

e_lambda=lambda_d-u(6);
r_L1=L*r1;

K_lambda=10;  
lambda_r=lambda_d+K_lambda*e_lambda;
%%%%%%%%%%%%%%%%%%%%%%%%%

Kp=[5 0;0 5];
tol=D1*ddqr1+C1*dqr1+G1+Kp*r_L1+J'*lambda_r;

tolf=J'*lambda;

sys(1)=tol(1);
sys(2)=tol(2);
sys(3)=lambda;