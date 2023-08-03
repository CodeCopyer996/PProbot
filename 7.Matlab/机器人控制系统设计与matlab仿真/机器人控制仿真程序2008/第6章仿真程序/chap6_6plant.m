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
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0 0 0 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
J1=0.3575;
Jd=0.000425;
gr=4;
c1=0.004;
c2=0.05;
k=8.45;

q1=x(1);dq1=x(2);
q2=x(3);dq2=x(4);

Td=u(1);
Tl=0.5*sin(t);

S1=1/Jd*(Td-c1*dq1-k*1/gr*(1/gr*q1-q2));
S2=-1/J1*(c2*dq2+k*(q2-1/gr*q1)+Tl);

sys(1)=x(2);
sys(2)=S1;
sys(3)=x(4);
sys(4)=S2;
function sys=mdlOutputs(t,x,u)

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);