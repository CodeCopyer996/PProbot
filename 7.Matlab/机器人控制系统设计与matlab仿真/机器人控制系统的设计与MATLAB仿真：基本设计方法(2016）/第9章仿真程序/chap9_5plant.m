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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[1.4 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
tol=u(1:2);

q1=x(1);q2=pi-2*x(1);

dq1=x(2);dq2=-2*dq1;

p=[2.9 0.76 0.87 3.04 0.87];
g=9.8;
 
D=[p(1)+p(2)+2*p(3)*cos(q2) p(2)+p(3)*cos(q2);
    p(2)+p(3)*cos(q2) p(2)];
C=[-p(3)*dq2*sin(q2) -p(3)*(dq1+dq2)*sin(q2);
     p(3)*dq1*sin(q2)  0];
G=[p(4)*g*cos(q1)+p(5)*g*cos(q1+q2);
    p(5)*g*cos(q1+q2)];

L=[1 -2]';

DL=L'*D*L;
CL=L'*C*L;
GL=L'*G;

ddq1=(L'*tol-CL*dq1-GL)/DL;

sys(1)=dq1;
sys(2)=ddq1;
function sys=mdlOutputs(t,x,u)
l1=1;l2=1;
tol=u(1:2);

q1=x(1);q2=pi-2*x(1);

dq1=x(2);dq2=-2*dq1;

p=[2.9 0.76 0.87 3.04 0.87];
g=9.8;
 
D=[p(1)+p(2)+2*p(3)*cos(q2) p(2)+p(3)*cos(q2);
    p(2)+p(3)*cos(q2) p(2)];
C=[-p(3)*dq2*sin(q2) -p(3)*(dq1+dq2)*sin(q2);
     p(3)*dq1*sin(q2)  0];
G=[p(4)*g*cos(q1)+p(5)*g*cos(q1+q2);
    p(5)*g*cos(q1+q2)];

L=[1 -2]';

DL=L'*D*L;
CL=L'*C*L;
GL=L'*G;

ddq1=DL\(L'*tol-CL*dq1-GL);

D1=D*L;
C1=C*L;
G1=G;

J=[-l1*sin(q1)-l2*sin(q1+q2) -l2*sin(q1+q2)];
temp=tol-D1*ddq1-C1*dq1-G1;

if q1+q2==pi
    lambda=0;
else
    lambda1=temp(1)/J(1);lambda2=temp(2)/J(2);  %lambda1=lambda2
    lambda=lambda1;
end
sys(1)=x(1);
sys(2)=x(2); 
sys(3)=pi-2*x(1);   %q2
sys(4)=-2*x(2);     %dq2
sys(5)=lambda;