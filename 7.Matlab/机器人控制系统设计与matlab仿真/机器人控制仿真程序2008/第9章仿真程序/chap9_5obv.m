function [sys,x0,str,ts]=s_function(t,x,u,flag)
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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0;0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
r=sin(t);
dr=cos(t);
ddr=-sin(t);

ut=u(1);
dth=u(3);
de=dr-dth;

k1=1500;
k2=200;

a=5;b=15;
sys(1)=k1*(de-x(2));
sys(2)=x(1)-a*ut+k2*(de-x(2))+ddr+b*dth;
function sys=mdlOutputs(t,x,u)

sys(1)=x(1);