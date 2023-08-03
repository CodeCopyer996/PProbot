function [sys,x0,str,ts]=s_function(t,x,u,flag)

switch flag,
%Initialization
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
%Outputs
  case 3,
    sys=mdlOutputs(t,x,u);
%Unhandled flags
  case {2, 4, 9 }
    sys = [];
%Unexpected flags
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

%mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.10,0,0.10,0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
tol=[u(1);u(2)];
q1=x(1);
dq1=x(2);
q2=x(3);
dq2=x(4);

m1=0.5;m2=0.5;
r1=1;r2=0.8;
g=9.8;

D11=(m1+m2)*r1^2+m2*r2^2+2*m2*r1*r2*cos(q2);
D12=m2*r2^2+m2*r1*r2*cos(q2);
D22=m2*r2^2;
D=[D11 D12;D12 D22];

F12=m2*r1*r2*sin(q2);
C=[-F12*dq2 -F12*(dq1+dq2);
   F12*dq1 0];

g1=(m1+m2)*r1*cos(q2)+m2*r2*cos(q1+q2);
g2=m2*r2*cos(q1+q2);
G=[g1*g;g2*g];

d0=1.5;d1=1.5;d2=1.5;
q1_d=sin(pi*t);
dq1_d=pi*cos(pi*t);
ddq1_d=-pi^2*sin(pi*t);

q2_d=sin(pi*t);
dq2_d=pi*cos(pi*t);

qd=[q1_d;q2_d];
dqd=[dq1_d;dq2_d];

q=[q1;q2];
dq=[dq1;dq2];

ur=d0+d1*norm(dq-dqd)+d2*norm(q-qd);

%robot dynamic equation as
S=inv(D)*(tol-C*[dq1;dq2]-G-ur);      

sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);