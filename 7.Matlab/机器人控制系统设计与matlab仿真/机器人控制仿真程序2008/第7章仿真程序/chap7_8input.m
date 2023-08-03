function [sys,x0,str,ts] = input(t,x,u,flag)
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
sizes.NumOutputs =6;
sizes.NumInputs = 0;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
q1_d=sin(pi*t);
dq1_d=pi*cos(pi*t);
ddq1_d=-pi^2*sin(pi*t);

q2_d=sin(pi*t);
dq2_d=pi*cos(pi*t);
ddq2_d=-pi^2*sin(pi*t);

sys(1)=q1_d;
sys(2)=dq1_d;
sys(3)=ddq1_d;
sys(4)=q2_d;
sys(5)=dq2_d;
sys(6)=ddq2_d;