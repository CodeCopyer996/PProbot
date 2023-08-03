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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.50 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
ut=u(1);
q1=x(1);q2=x(2);

m=0.02;g=9.8;l=0.05;
g0=m*g*l*cos(q1);

M0=0.1+0.06*sin(q1);
C0=0.03*cos(q1)+0.5*q2^2;
fx=inv(M0)*(-C0-g0);
gx=inv(M0);

sys(1)=x(2);
sys(2)=fx+gx*(ut+3*sin(t)); 
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);