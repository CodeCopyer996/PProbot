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
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0; 
sys = simsizes(sizes);
x0  = [0,0];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
a1=20;a0=30;b=50;
r=sign(sin(0.025*2*pi*t));   %Square Signal

sys(1)=x(2); 
sys(2)=-a1*x(2)-a0*x(1)+b*r;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);