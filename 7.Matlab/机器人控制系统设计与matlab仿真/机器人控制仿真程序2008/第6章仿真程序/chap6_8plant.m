function [sys,x0,str,ts] = robot(t,x,u,flag,state)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes(state);
  case 1,
    sys=mdlDerivatives(t,x,u,state);
   case 3,
    sys=mdlOutputs(t,x,u);
   case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes(state)
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   
sys = simsizes(sizes);
x0  = [1 1 0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u,state)
v=u(1);
w=u(2);
dx1=v*cos(x(3));
dx2=v*sin(x(3));
dx3=w;

sys=[dx1,dx2,dx3];
function sys=mdlOutputs(t,x,u)
sys=x;