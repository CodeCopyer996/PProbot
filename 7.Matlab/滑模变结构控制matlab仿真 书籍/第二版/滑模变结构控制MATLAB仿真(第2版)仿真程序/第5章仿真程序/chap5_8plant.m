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
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.1;0;0.05;0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
I=1.0;J=1.0;Mgl=5.0;K=40;
a1=K/I;
f1=-Mgl/I*sin(x(1))-K/I*x(1);
a2=1/J;
f2=K/J*(x(1)-x(3));
delta1=sin(t);
delta2=cos(t);

ut=u(1);
sys(1)=x(2);
sys(2)=a1*x(3)+f1+delta1;
sys(3)=x(4);
sys(4)=a2*ut+f2+delta2;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);