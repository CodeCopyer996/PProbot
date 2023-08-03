%S-function for continuous state equation
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
x0=[0.6;0.3;0.5;0.5];
str=[];
ts=[];

function sys=mdlDerivatives(t,x,u)
qd1=cos(pi*t);
dqd1=-pi*sin(pi*t);
ddqd1=-pi^2*cos(pi*t);
qd2=sin(pi*t);
dqd2=pi*cos(pi*t);
ddqd2=-pi^2*sin(pi*t);

q1=x(1);
dq1=x(2);
q2=x(3);
dq2=x(4);

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

tol(1)=u(1);
tol(2)=u(2);

ddq=inv(M)*(tol'-B*[dq1;dq2]+w);

sys(1)=x(2);
sys(2)=ddq(1);
sys(3)=x(4);
sys(4)=ddq(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);