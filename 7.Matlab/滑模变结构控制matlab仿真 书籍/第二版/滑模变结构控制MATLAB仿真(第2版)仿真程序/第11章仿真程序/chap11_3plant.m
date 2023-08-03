function [sys,x0,str,ts]=s_function(t,x,u,flag)
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
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.5;0;0.5;0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
q1=x(1);
dq1=x(2);
q2=x(3);
dq2=x(4);

M=[0.1+0.01*cos(q2) 0.01*sin(q2);
   0.01*sin(q2) 0.1];
H=[-0.005*sin(q2)*dq2;
   0.05*cos(q2)*dq2];
dt=[2*sin(2*pi*t);3*cos(2*pi*t)];

tol(1)=u(1);
tol(2)=u(2);

S=inv(M)*(tol'-H-dt);

sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);