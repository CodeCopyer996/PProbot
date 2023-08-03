function [sys,x0,str,ts] = control_strategy(t,x,u,flag)
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
sizes.NumInputs      = 13;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
q1_d=u(1);dq1_d=u(2);ddq1_d=u(3);
q2_d=u(4);dq2_d=u(5);ddq2_d=u(6);

q1=u(7);dq1=u(8);
q2=u(9);dq2=u(10);

q=[q1;q2];
dq=[dq1;dq2];

qd=[q1_d;q2_d];
dqd=[dq1_d;dq2_d];
ddqd=[ddq1_d;ddq2_d];

xite1=u(11);
xite2=u(12);
xite3=u(13);

F=5*eye(2);
s=(dq-dqd)+F*(q-qd);
s1=s(1);s2=s(2);

dqr=dqd-F*(q-qd);
ddqr=ddqd-F*(dq-dqd);

dq1r=dqr(1);
ddq1r=ddqr(1);
dq2r=dqr(2);
ddq2r=ddqr(2);

r1=1;g=9.8;
e=g/r1;
Fai11=ddq1r+e*cos(q2);
Fai12=ddq1r+ddq2r;
Fai13=2*ddq1r*cos(q2)+ddq2r*cos(q2)-dq2*dq1r*sin(q2)-(dq1+dq2)*dq2r*sin(q2)+e*cos(q1+q2);

Fai21=0;
Fai22=Fai12;
Fai23=dq1*dq1r*sin(q2)+ddq1r*cos(q2)+e*cos(q1+q2);

Fai=[Fai11 Fai12 Fai13;
     Fai21 Fai22 Fai23];
     
M=1;     
if M==1
    fai1=-xite1*sign(s1*Fai11+s2*Fai21);
    fai2=-xite2*sign(s1*Fai12+s2*Fai22);
    fai3=-xite3*sign(s1*Fai13+s2*Fai23);
elseif M==2
  	delta=0.15;
    Q1=s1*Fai11+s2*Fai21;
    Q2=s1*Fai12+s2*Fai22;
    Q3=s1*Fai13+s2*Fai23;
    if Q1>delta
		sat1=1;
	elseif abs(Q1)<=delta
		sat1=Q1/delta;
	elseif Q1<-delta
		sat1=-1;
	end
    if Q2>delta
		sat2=1;
	elseif abs(Q2)<=delta
		sat2=Q2/delta;
	elseif Q2<-delta
		sat2=-1;
	end
    if Q3>delta
		sat3=1;
	elseif abs(Q3)<=delta
		sat3=Q3/delta;
	elseif Q3<-delta
		sat3=-1;
	end
    fai1=-xite1*sat1;
    fai2=-xite2*sat2;
    fai3=-xite3*sat3;
end
fai=[fai1;fai2;fai3];

Kd=10*eye(2);
tol=Fai*fai-Kd*s;

sys(1)=tol(1);
sys(2)=tol(2);