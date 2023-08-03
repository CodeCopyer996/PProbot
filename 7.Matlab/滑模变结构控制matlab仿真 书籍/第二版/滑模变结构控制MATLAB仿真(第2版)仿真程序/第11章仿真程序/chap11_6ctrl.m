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
sizes.NumInputs      = 14;
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

alfa_p=u(11);
beta_p=u(12);
epc_p=u(13);
eta_p=u(14);

m1=1;l1=1;
lc1=1/2;I1=1/12;
g=9.8;
e1=m1*l1*lc1-I1-m1*l1^2;
e2=g/l1;

dq_d=[dq1_d,dq2_d]';
ddq_d=[ddq1_d,ddq2_d]';

q_error=[q1-q1_d,q2-q2_d]';
dq_error=[dq1-dq1_d,dq2-dq2_d]';


H_p=[alfa_p+2*epc_p*cos(q2)+2*eta_p*sin(q2),beta_p+epc_p*cos(q2)+eta_p*sin(q2);
     beta_p+epc_p*cos(q2)+eta_p*sin(q2),beta_p];
C_p=[(-2*epc_p*sin(q2)+2*eta_p*cos(q2))*dq2,(-epc_p*sin(q2)+eta_p*cos(q2))*dq2;
     (epc_p*sin(q2)-eta_p*cos(q2))*dq1,0];
G_p=[epc_p*e2*cos(q1+q2)+eta_p*e2*sin(q1+q2)+(alfa_p-beta_p+e1)*e2*cos(q1);
     epc_p*e2*cos(q1+q2)+eta_p*e2*sin(q1+q2)];

Fai=5*eye(2);
dqr=dq_d-Fai*q_error;
ddqr=ddq_d-Fai*dq_error;
s=Fai*q_error+dq_error;
Kd=100*eye(2);
tol=H_p*ddqr+C_p*dqr+G_p-Kd*s;

sys(1)=tol(1);
sys(2)=tol(2);