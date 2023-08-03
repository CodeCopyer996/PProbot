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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1; % At least one sample time is needed
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,x,u)
r=u(1);
dr=0.5*2*pi*cos(2*pi*t);
ddr=-0.5*(2*pi)^2*sin(2*pi*t);

R=[r;dr];
dR=[dr;ddr];
X=[u(2);u(3)];

xe=R-X;

A=[0 1;0 -25];
B=[0;133];

K=[-100,-10];
c1=3;
C=[c1,1];

int=C*(A+B*K)*xe;
s=C*(xe-u(4));

f=0.10;
ut=inv(B'*B)*B'*(dR-A*R)-K*xe+f*sign(s);

sys(1)=ut;
sys(2)=int;