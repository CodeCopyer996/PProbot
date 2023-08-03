function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 8;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
r1=u(1);r2=u(2);
dr1=u(3);dr2=u(4);

y1=u(5);y2=u(7);
dy1=u(6);dy2=u(8);

e1=r1-y1;
de1=dr1-dy1;
e2=r2-y2;
de2=dr2-dy2;

kp=20;kd=5;
ut=[kp*e1+kd*de1;kp*e2+kd*de2];

sys(1)=ut(1);
sys(2)=ut(2);