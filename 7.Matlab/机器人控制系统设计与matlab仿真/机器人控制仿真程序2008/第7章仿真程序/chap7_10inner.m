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
sizes.NumOutputs     =2;
sizes.NumInputs      =10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
v=13.33;m1=8.98;m2=8.75;g=9.8;
q1=u(7);q2=u(8);
q=[q1 q2]';
dq1=u(9);dq2=u(10);
dq=[dq1 dq2]';

M=[v+m1+2*m2*cos(q2) m1+m2*cos(q2);
   m1+m2*cos(q2) m1];
C=[-m2*dq2*sin(q2) -m2*(dq1+dq2)*sin(q2);
    m2*dq1*sin(q2)  0];
G=[15*g*cos(q1)+8.75*g*cos(q1+q2);
   8.75*g*cos(q1+q2)];
k2=1;niu=1200;rou2=1.5;

sn=[u(1) u(2)]';
S=sign(sn);
we=[u(3) u(4)]';
dwd=[u(5) u(6)]';
tol=M*(dwd+k2*we)+C*dq+C*sn+G+niu*sn+rou2*S;

sys(1)=tol(1);
sys(2)=tol(2);