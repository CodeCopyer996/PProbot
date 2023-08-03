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
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
alfa=6.7;beta=3.4;epc=3.0;eta=0;

q1_d=u(1);dq1_d=u(2);ddq1_d=u(3);
q2_d=u(4);dq2_d=u(5);ddq2_d=u(6);
q1=u(7);dq1=u(8);
q2=u(9);dq2=u(10);

m1=1;l1=1;
lc1=1/2;I1=1/12;
g=9.8;
e1=m1*l1*lc1-I1-m1*l1^2;
e2=g/l1;

dq_d=[dq1_d,dq2_d]';
ddq_d=[ddq1_d,ddq2_d]';

q_error=[q1-q1_d,q2-q2_d]';
dq_error=[dq1-dq1_d,dq2-dq2_d]';

H=[alfa+2*epc*cos(q2)+2*eta*sin(q2),beta+epc*cos(q2)+eta*sin(q2);
     beta+epc*cos(q2)+eta*sin(q2),beta];
C=[(-2*epc*sin(q2)+2*eta*cos(q2))*dq2,(-epc*sin(q2)+eta*cos(q2))*dq2;
     (epc*sin(q2)-eta*cos(q2))*dq1,0];
G=[epc*e2*cos(q1+q2)+eta*e2*sin(q1+q2)+(alfa-beta+e1)*e2*cos(q1);
     epc*e2*cos(q1+q2)+eta*e2*sin(q1+q2)];

    Fai=5*eye(2);
    dqr=dq_d-Fai*q_error;
    ddqr=ddq_d-Fai*dq_error;
    s=Fai*q_error+dq_error;
    Kd=100*eye(2);
    tol=H*ddqr+C*dqr+G-Kd*s;
sys(1)=tol(1);
sys(2)=tol(2);