function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumOutputs=4;
sizes.NumInputs=10;
sizes.DirFeedthrough=1;
sizes.NumSampleTimes=1;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[0 0];
function sys=mdlOutputs(t,x,u)
qd1=u(1);
dqd1=u(2);
ddqd1=u(3);
qd2=u(4);
dqd2=u(5);
ddqd2=u(6);

dqd=[dqd1 dqd2]';
ddqd=[ddqd1 ddqd2]';

q1=u(7);
dq1=u(8);
q2=u(9);
dq2=u(10);

e1=qd1-q1;
de1=dqd1-dq1;
e2=qd2-q2;
de2=dqd2-dq2;
e=[e1 e2];
de=[de1 de2];

Hur=5*eye(2);
r=de'+Hur*e';

dqr=dqd+Hur*e';
ddqr=ddqd+Hur*de';

m1=0.5;m2=0.5;
r1=1;r2=0.8;
g=9.8;
M11=(m1+m2)*r1^2+m2*r2^2+2*m2*r1*r2*cos(q2);
M12=m2*r2^2+m2*r1*r2*cos(q2);
M22=m2*r2^2;
M=[M11 M12;M12 M22];

V12=m2*r1*r2*sin(q2);
V=[-V12*dq2 -V12*(dq1+dq2);
   V12*dq1 0];

g1=(m1+m2)*r1*cos(q2)+m2*r2*cos(q1+q2);
g2=m2*r2*cos(q1+q2);
G=[g1*g;g2*g];

fp=M*(ddqd+Hur*de')+V*(dqd+Hur*e')+G;
Kv=500*eye(2);
fM=0;
v=-fM*sign(r);

M=2;
if M==1
    kp=200*eye(2);kd=80*eye(2);
    w=kp*e'+kd*de';   %PD control
elseif M==2
    w=fp+Kv*r-v;
end
sys(1)=w(1);
sys(2)=w(2);
sys(3)=r(1);
sys(4)=r(2);