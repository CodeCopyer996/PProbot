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
x0=[0.8,0.2,0.2];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
q1_d=u(1);
dq1_d=u(2);
ddq1_d=u(3);

q2_d=u(4);
dq2_d=u(5);
ddq2_d=u(6);

q1=u(7);
dq1=u(8);
q2=u(9);
dq2=u(10);

q=[q1;q2];
dq=[dq1;dq2];

qd=[q1_d;q2_d];
dqd=[dq1_d;dq2_d];
ddqd=[ddq1_d;ddq2_d];

g=9.8;r1=1;
e=g/r1;

F=5*eye(2);
dqr=dqd-F*(q-qd);
ddqr=ddqd-F*(dq-dqd);

dq1r=dqr(1);
ddq1r=ddqr(1);
dq2r=dqr(2);
ddq2r=ddqr(2);

s=(dq-dqd)+F*(q-qd);
s1=s(1);s2=s(2);

Fai11=ddq1r+e*cos(q2);
Fai12=ddq1r+ddq2r;
Fai13=2*ddq1r*cos(q2)+ddq2r*cos(q2)-dq2*dq1r*sin(q2)-(dq1+dq2)*dq2r*sin(q2)+e*cos(q1+q2);

Fai21=0;
Fai22=Fai12;
Fai23=dq1*dq1r*sin(q2)+ddq1r*cos(q2)+e*cos(q1+q2);

Gama1=0.005;
Gama2=0.005;
Gama3=0.005;

dxite1=Gama1*abs(s1*Fai11+s2*Fai21);
dxite2=Gama2*abs(s1*Fai12+s2*Fai22);
dxite3=Gama3*abs(s1*Fai13+s2*Fai23);

%The adaptive law is proposed by Chun-Yi Su(1993)
sys(1)=dxite1;
sys(2)=dxite2;
sys(3)=dxite3;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);