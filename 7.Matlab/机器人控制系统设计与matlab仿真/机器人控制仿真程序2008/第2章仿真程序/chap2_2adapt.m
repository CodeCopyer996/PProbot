function [sys,x0,str,ts]=para_estimate(t,x,u,flag)
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
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[4.1,1.9,1.7];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
q1_d=u(1);dq1_d=u(2);ddq1_d=u(3);
q2_d=u(4);dq2_d=u(5);ddq2_d=u(6);

q1=u(7);dq1=u(8);
q2=u(9);dq2=u(10);

q_error=[q1-q1_d,q2-q2_d]';
dq_error=[dq1-dq1_d,dq2-dq2_d]';

gama=5*eye(2);
y=gama*q_error+dq_error;
ddq_d=[ddq1_d,ddq2_d]';
dq_d=[dq1_d,dq2_d]';

dqr=dq_d-gama*q_error;
ddqr=ddq_d-gama*dq_error;

g=9.8;r1=1;
e1=g/r1;
fai11=ddqr(1)+e1*cos(q2);
fai12=ddqr(1)+ddqr(2);
fai13=2*ddqr(1)*cos(q2)+ddqr(2)*cos(q2)-dq2*dqr(1)*sin(q2)-(dq1+dq2)*dqr(2)*sin(q2)+e1*cos(q1+q2);

fai21=0;
fai22=fai12;
fai23=dq1*dqr(1)*sin(q2)+ddqr(1)*cos(q2)+e1*cos(q1+q2);
FAI=[fai11 fai12 fai13;
     fai21 fai22 fai23];
Gama=5*eye(3);
S=-Gama*FAI'*y;
for i=1:1:3
    sys(i)=S(i);
end

function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);