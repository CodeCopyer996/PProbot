function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 7;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0; 
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];

function sys=mdlOutputs(t,x,u)
rou1=0.005;
rou2=0.005;
rou3=0.005;
I1=720;I2=800;I3=550;
I=1/3*(I1+I2+I3);

k=2.0;k1=2.0;k2=2.0;k3=2.0;
q0d=1;q1d=0;q2d=0;q3d=0;

x=u;
ep=0.15;w0=0.15;
M1=-(rou1*sign(x(1))+k*I*(ep+1-exp(-w0*t))*(q0d*x(5)-q1d*x(4)-q2d*x(7)+q3d*x(6)+k1*x(1)));
M2=-(rou2*sign(x(2))+k*I*(ep+1-exp(-w0*t))*(q0d*x(6)+q1d*x(7)-q2d*x(4)-q3d*x(5)+k2*x(2)));
M3=-(rou3*sign(x(3))+k*I*(ep+1-exp(-w0*t))*(q0d*x(7)-q1d*x(6)+q2d*x(5)-q3d*x(4)+k3*x(3)));

M=[M1,M2,M3];
for i=1:1:3
    sys(i)=M(i);
end