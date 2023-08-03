function [sys,x0,str,ts] = obv(t,x,u,flag)
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
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;0;0;0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
I=1.0;J=1.0;Mgl=5.0;K=40;l1=5;l2=5;

D1=4;D2=1;D3=4;D4=1;
D2_bar=D2+l1*D1;
D4_bar=D4+l2*D3;

ut=u(1);
x1=u(2);
x3=u(3);
a1=K/I;a2=1/J;
f1=-Mgl/I*sin(x1)-K/I*x1;
f2=K/J*(x1-x3);
sys(1)=x(2)+l1*(x1-x(1))+D1*(x1-x(1));
sys(2)=a1*x3+f1+D2_bar*(x1-x(1));
sys(3)=x(4)+l2*(x3-x(3))+D3*(x3-x(3));
sys(4)=a2*ut+f2+D4_bar*(x3-x(3));
function sys=mdlOutputs(t,x,u)
l1=5;l2=5;

ut=u(1);
x1=u(2);
x3=u(3);

sys(1)=x(1);
sys(2)=x(2)+l1*(x1-x(1));
sys(3)=x(3);
sys(4)=x(4)+l2*(x3-x(3));