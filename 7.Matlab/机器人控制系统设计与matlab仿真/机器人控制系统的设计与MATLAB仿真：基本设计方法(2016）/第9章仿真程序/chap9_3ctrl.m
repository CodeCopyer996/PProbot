function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
qd1=u(1);
dqd1=u(2);
ddqd1=u(3);
qd2=u(4);
dqd2=u(5);
ddqd2=u(6);

q1=u(7);dq1=u(8);
q2=u(9);dq2=u(10);
dq=[dq1 dq2]';

l1=0.25;l2=0.25;
P=[1.66 0.42 0.63 3.75 1.25];
g=9.8;
L=[l1^2 l2^2 l1*l2 l1 l2];
pl=0.5;
M=P+pl*L;

D=[M(1)+M(2)+2*M(3)*cos(q2) M(2)+M(3)*cos(q2);
    M(2)+M(3)*cos(q2) M(2)];
C=[-M(3)*dq2*sin(q2) -M(3)*(dq1+dq2)*sin(q2);
    M(3)*dq1*sin(q2)  0];
G=[M(4)*g*cos(q1)+M(5)*g*cos(q1+q2);
   M(5)*g*cos(q1+q2)];

e1=q1-qd1;
e2=q2-qd2;
de1=dq1-dqd1;
de2=dq2-dqd2;
e=[e1;e2];
de=[de1;de2];
 
Hur=50*eye(2);
s=de+Hur*e;
 
dqd=[dqd1;dqd2];
dqr=dqd-Hur*e;
ddqd=[ddqd1;ddqd2];
ddqr=ddqd-Hur*de;
 
KD=130*eye(2);
tol=D*ddqr+C*dqr+G-KD*s;

sys(1:2)=tol(1:2);