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
dqd1=-sin(t);
ddqd1=-cos(t);

qd2=u(2);
dqd2=cos(t);
ddqd2=-sin(t);

q1=u(3);dq1=u(4);
q2=u(5);dq2=u(6);

e1=qd1-q1;
e2=qd2-q2;
de1=dqd1-dq1;
de2=dqd2-dq2;

M=[0.1+0.01*cos(q2) 0.01*sin(q2);
   0.01*sin(q2) 0.1];
H=[-0.005*sin(q2)*dq2;
   0.05*cos(q2)*dq2];
ddqd=[ddqd1;ddqd2];

c1=5;c2=5;
s1=c1*e1+de1;
s2=c2*e2+de2;
s=[s1;s2];

f1U=2;f2U=3;
eq=0.5;k=5;

%Saturated function
fai=0.02;
if abs(s1)<=fai
   sat1=s1/fai;
else
   sat1=sign(s1);
end
if abs(s2)<=fai
   sat2=s2/fai;
else
   sat2=sign(s2);
end

F=2;
if F==1
    fc1=f1U*sign(s1);
    fc2=f2U*sign(s2);
elseif F==2
    fc1=f1U*sat1;
    fc2=f2U*sat2;
end
fc=-[fc1;fc2];
ut=M*([c1*de1;c2*de2]+ddqd+eq*sign(s)+k*s)+H-fc;

sys(1)=ut(1);
sys(2)=ut(2);