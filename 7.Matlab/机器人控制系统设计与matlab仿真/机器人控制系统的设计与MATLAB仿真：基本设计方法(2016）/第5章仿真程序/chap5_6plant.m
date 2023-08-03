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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;1];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
g=9.8;
m=1.0;
l=1.25;
d=2.0;
I=4/3*m*l^2;

q=x(1);
dq=x(2);

tol=u(1);
dk=rand(1)*sin(t);
S=inv(I)*(tol+dk-m*g*l*cos(q)-d*dq);

sys(1)=x(2);
sys(2)=S;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);   %Angle:q
sys(2)=x(2);   %Angle speed:dq