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
x0  = [0.2;0;0;0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
I=1.0;J=1.0;Mgl=5.0;K=40;
ut=u(1);
sys(1)=x(2);
sys(2)=-(1/I)*(Mgl*sin(x(1))+K*(x(1)-x(3)));
sys(3)=x(4);
sys(4)=(1/J)*(ut+K*(x(1)-x(3)));
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);