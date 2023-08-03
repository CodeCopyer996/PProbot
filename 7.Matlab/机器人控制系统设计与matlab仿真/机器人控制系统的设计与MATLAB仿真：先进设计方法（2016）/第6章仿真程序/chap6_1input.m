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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0; 
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
A=0.50;w=3;
x1d=A*sin(w*2*pi*t);
dx1d=w*2*pi*A*cos(w*2*pi*t);
ddx1d=-(w*2*pi)^2*A*sin(w*2*pi*t);
dddx1d=-(w*2*pi)^3*A*cos(w*2*pi*t);
ddddx1d=(w*2*pi)^4*A*sin(w*2*pi*t);

sys(1)=x1d;
sys(2)=dx1d;
sys(3)=ddx1d;
sys(4)=dddx1d;
sys(5)=ddddx1d;