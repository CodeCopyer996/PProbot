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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
qd1=u(1);
dqd1=-pi*sin(pi*t);
ddqd1=-pi^2*cos(pi*t);
qd2=u(2);
dqd2=pi*cos(pi*t);
ddqd2=-pi^2*sin(pi*t);

dqd=[dqd1;dqd2];
ddqd=[ddqd1;ddqd2];

q1=u(3);dq1=u(4);
q2=u(5);dq2=u(6);
dq=[dq1;dq2];

e1=qd1-q1;
e2=qd2-q2;
e=[e1;e2];
de1=dqd1-dq1;
de2=dqd2-dq2;
de=[de1;de2];

v=13.33;
q01=8.98;
q02=8.75;
g=9.8;
M=[v+q01+2*q02*cos(q2) q01+q02*cos(q2);
   q01+q02*cos(q2) q01];
B=[-q02*dq2*sin(q2) -q02*(dq1+dq2)*sin(q2);
   q02*dq1*sin(q2)  0];
w=[15*g*cos(q1)+8.75*g*cos(q1+q2);
   8.75*g*cos(q1+q2)];
M0=0.8*M;
B0=0.8*B;
w0=0.8*w;

dM=M0-M;
dB=B0-B;
dw=w0-w;
    
c1=20;c2=20;
C=[c1 0;0 c2];
s=de+C*e;

F=2;
if F==1
    K1=[10 0;0 10];
    K2=[10 0;0 10];    
    tol=M*(ddqd++K1*de+K2*e)+B*dq-w;    
elseif F==2
    temp=abs(dM)*abs(ddqd+C*de)+abs(dw)+abs(dB)*abs(dqd+C*e)+0.10;
    gama=[temp(1) 0;0 temp(2)];
    tol=M0*(ddqd+C*de)+B0*(dqd+C*e)-w0+gama*sign(s);
end
sys(1)=tol(1);
sys(2)=tol(2);