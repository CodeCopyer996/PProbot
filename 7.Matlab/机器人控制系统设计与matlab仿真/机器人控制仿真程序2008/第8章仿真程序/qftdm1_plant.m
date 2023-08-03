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
sizes.NumOutputs     = 1;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
M=1;
if M==1
    a=1+4*abs(sin(2*pi*t));
    b=20+10*abs(sin(2*pi*t));
    k=1+9*abs(sin(2*pi*t));
elseif M==2
    a=5;
    b=30;
    k=1;
end    
ut=u(1);

sys(1)=x(2);
sys(2)=-(a+b)*x(2)-a*b*x(1)+k*ut;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);