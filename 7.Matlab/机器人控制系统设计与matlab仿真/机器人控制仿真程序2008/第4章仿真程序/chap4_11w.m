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
sizes.NumOutputs=2;
sizes.NumInputs=5;
sizes.DirFeedthrough=1;
sizes.NumSampleTimes=1;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[0 0];
function sys=mdlOutputs(t,x,u)
qd=u(1);
dqd=u(2);
ddqd=u(3);
q=u(4);
dq=u(5);

e=qd-q;
de=dqd-dq;
Hur=5;
r=de+Hur*e;

dqr=dqd+Hur*e;
ddqr=ddqd+Hur*de;

K=10;
a=20;
fp=1/K*(ddqd+Hur*de)+a/K*(dqd+Hur*e);
Kv=200;
fM=0;
v=-fM*sign(r);

M=2;
if M==1
    kp=200;kd=80;
    w=kp*e+kd*de;   %PD control
elseif M==2
    w=fp+Kv*r-v;
end
sys(1)=w;
sys(2)=r;