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
global I J Mgl K
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;0;0;0];
str = [];
ts  = [0 0];

I=1.0;J=1.0;Mgl=5.0;K=1200;
function sys=mdlDerivatives(t,x,u)
global I J Mgl K
dt=200000*sin(3*pi*t);

tol=u(1);
sys(1)=x(2);
sys(2)=-(1/I)*(Mgl*sin(x(1))+K*(x(1)-x(3)));
sys(3)=x(4);
sys(4)=(1/J)*(tol-dt-K*(x(3)-x(1)));
function sys=mdlOutputs(t,x,u)
global I J Mgl K

dx2=-(1/I)*(Mgl*sin(x(1))+K*(x(1)-x(3)));
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);
sys(5)=dx2;