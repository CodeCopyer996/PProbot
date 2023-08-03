function [sys,x0,str,ts] = spacemodel(t,x,u,flag)

switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)
alfa=250;
r=u(1);
dr=0.5*2*pi*cos(2*pi*t);

R=[r;dr];
X=[u(2);u(3)];

xe=R-X;

C=[3,1];
s=C*xe-u(4);

B=[0;133];
sys(1)=1/alfa*abs(s*C*B);
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
C=[3,1];

int=C*(A+B*K)*xe;
s=C*xe-u(4);

ut=inv(B'*B)*B'*(dR -A*R)-K*xe+x(1)*sign(s);

sys(1)=ut;
sys(2)=int;
sys(3)=x(1);