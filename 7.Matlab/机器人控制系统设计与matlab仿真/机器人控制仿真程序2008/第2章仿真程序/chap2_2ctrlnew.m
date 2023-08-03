function [sys,x0,str,ts] = control_strategy(t,x,u,flag)
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
sizes.NumContStates  = 2;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 13;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0;0];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
q1_d=u(1);dq1_d=u(2);ddq1_d=u(3);
q2_d=u(4);dq2_d=u(5);ddq2_d=u(6);
q1=u(7);dq1=u(8);
q2=u(9);dq2=u(10);

r1=1;
g=9.8;
e1=g/r1;

dq_d=[dq1_d,dq2_d]';
ddq_d=[ddq1_d,ddq2_d]';

e=[q1-q1_d,q2-q2_d]';
de=[dq1-dq1_d,dq2-dq2_d]';
f=max([1,norm(e),norm(de)]);

gama=5*eye(2);
y=gama*e+de;

gama1=20;gama2=20;
sys(1)=gama1*f*norm(y);
sys(2)=-gama2*x(2);
function sys=mdlOutputs(t,x,u)
q1_d=u(1);dq1_d=u(2);ddq1_d=u(3);
q2_d=u(4);dq2_d=u(5);ddq2_d=u(6);
q1=u(7);dq1=u(8);
q2=u(9);dq2=u(10);

dq_d=[dq1_d,dq2_d]';
ddq_d=[ddq1_d,ddq2_d]';

e=[q1-q1_d,q2-q2_d]';
de=[dq1-dq1_d,dq2-dq2_d]';

gama=5*eye(2);
y=gama*e+de;
ddq_d=[ddq1_d,ddq2_d]';
dq_d=[dq1_d,dq2_d]';

dqr=dq_d-gama*e;
ddqr=ddq_d-gama*de;

f=max([1,norm(e),norm(de)]);
ut=-(x(1)*f)^2*y/(x(1)*f*norm(y)+x(2)^2+0.0000001);

Kp1=[180,0;0,190];
Kp2=[150,0;0,150];
Kv1=[180,0;0,180];
Kv2=[150,0;0,150];

alfa1=1;alfa2=1;
beta1=1;beta2=1;

p1=u(11);
p2=u(12);
p3=u(13);
P=[p1 p2 p3]';

r1=1;g=9.8;e1=g/r1;
fai11=ddqr(1)+e1*cos(q2);
fai12=ddqr(1)+ddqr(2);
fai13=2*ddqr(1)*cos(q2)+ddqr(2)*cos(q2)-dq2*dqr(1)*sin(q2)-(dq1+dq2)*dqr(2)*sin(q2)+e1*cos(q1+q2);

fai21=0;
fai22=fai12;
fai23=dq1*dqr(1)*sin(q2)+ddqr(1)*cos(q2)+e1*cos(q1+q2);

FAI=[fai11 fai12 fai13;
     fai21 fai22 fai23];

R=FAI*P;
tol(1)=-(Kp1(1,1)+Kp2(1,1)/(alfa1+abs(e(1))))*e(1)-(Kv1(1,1)+Kv2(1,1)/(beta1+abs(de(1))))*de(1)+R(1)+ut(1);
tol(2)=-(Kp1(2,2)+Kp2(2,2)/(alfa2+abs(e(2))))*e(2)-(Kv1(2,2)+Kv2(2,2)/(beta2+abs(de(2))))*de(2)+R(2)+ut(2);

sys(1)=tol(1);
sys(2)=tol(2);