function [sys,x0,str,ts] = Differentiator(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0 0 0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
vt=u(1);
epc=0.01;

k1=3;k2=3;k3=2;

sys(1)=x(2)-(k3/epc)*(x(1)-vt);%Kahlil TD
sys(2)=x(3)-(k2/(epc^2))*(x(1)-vt);
sys(3)=-(k1/(epc^3))*(x(1)-vt);
function sys=mdlOutputs(t,x,u)
sys = x;