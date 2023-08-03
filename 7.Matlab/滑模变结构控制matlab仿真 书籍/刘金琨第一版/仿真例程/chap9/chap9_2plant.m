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
sizes.NumContStates  = 9;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 9;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [1,0,0,0.5,0,0,0,0,0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)
f=[-1.5*x(3)^2*cos(3*x(4)),3*x(5)*sin(x(7)),x(9)*cos(x(1))*sin(x(4))];
b=[1 0 0;0 1 0;0 0 1];
df=[sin(t)*sin(x(5)^2)*cos(3*x(1)),exp(-t)*cos(x(3))*sin(x(7)),cos(t)*sin(x(6))];

sys(1)=x(2);
sys(2)=x(3);
sys(3)=f(1)+df(1)+u(1);

sys(4)=x(5);
sys(5)=x(6);
sys(6)=f(2)+df(2)+u(2);

sys(7)=x(8);
sys(8)=x(9);
sys(9)=f(3)+df(3)+u(3);

function sys=mdlOutputs(t,x,u)

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);
sys(5)=x(5);
sys(6)=x(6);
sys(7)=x(7);
sys(8)=x(8);
sys(9)=x(9);