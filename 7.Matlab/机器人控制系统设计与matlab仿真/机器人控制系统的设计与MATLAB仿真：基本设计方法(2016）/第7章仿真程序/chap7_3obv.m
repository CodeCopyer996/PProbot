function [sys,x0,str,ts]= NDO(t,x,u,flag)
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
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
J=1/133;C=25/133;G=0;

tol=u(1);
dth=u(3);
z=x(1);

X=1;
L=inv(X)*inv(J);
p=inv(X)*dth;
d=z+p;

dz=L*(C*dth+G-tol)-L*d;
sys(1)=dz;
function sys=mdlOutputs(t,x,u)
dth=u(3);
z=x(1);

X=1;
p=inv(X)*dth;
d=z+p;

sys(1)=d;