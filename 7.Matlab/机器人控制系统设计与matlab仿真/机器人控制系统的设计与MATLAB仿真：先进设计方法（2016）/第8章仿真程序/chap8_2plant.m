function [sys,x0,str,ts] = robot_model(t,x,u,flag)
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
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   
sys = simsizes(sizes);
x0  = [0.5 0.2 0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
a1=-0.05;a2=-0.09;
b1=0.25;b2=1.67;

ur=u(1);
ul=u(2);
dx1=a1*x(1)+b1*ur+b1*ul;
dx2=x(3);
dx3=a2*x(3)+b2*ur-b2*ul;
sys(1)=dx1;
sys(2)=dx2;
sys(3)=dx3;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);