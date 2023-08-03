function [sys,x0,str,ts]=MIMO_Tong_plant(t,x,u,flag)
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
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0 0 0 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)   
M=0.2;L=0.02;I=1.35*0.001;K=7.47;J=2.16*0.1;
g=9.8;

gx=-x(3)-M*g*L*sin(x(1))/I-(K/I)*(x(1)-x(3));
fx=(K/J)*(x(1)-x(3));
m=1/J;
ut=u(1);
sys(1)=x(2);
sys(2)=x(3)+gx;
sys(3)=x(4);
sys(4)=fx+m*ut;
function sys=mdlOutputs(t,x,u)
M=0.2;L=0.02;I=1.35*0.001;K=7.47;J=2.16*0.1;
g=9.8;

gx=-x(3)-M*g*L*sin(x(1))/I-(K/I)*(x(1)-x(3));
fx=(K/J)*(x(1)-x(3));
m=1/J;

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);
sys(5)=gx;