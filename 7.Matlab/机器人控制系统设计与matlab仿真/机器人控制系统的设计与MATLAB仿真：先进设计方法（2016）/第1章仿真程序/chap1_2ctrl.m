function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
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
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
yd=u(1);dyd=cos(t);ddyd=-sin(t);

x1=u(2);x2=u(3);

fx=-25*x2;
b=133;

z1=x1-yd;
dz1=x2-dyd;

%kb=0.50;
kb1=0.51;  %kb must bigger than z1(0)

xd_max=1.0;
xd_min=-1.0;

x1_max=kb1+xd_max;
x1_min=-kb1+xd_min;

k1=10;k2=10;

alfa=-(kb1^2-z1^2)*k1*z1+dyd;

z2=x2-alfa;

dalfa=2*k1*dz1*z1^2-(kb1^2-z1^2)*k1*dz1+ddyd;

temp=-fx+dalfa-k2*z2-z1/(kb1^2-z1^2);
ut=temp/b;

sys(1)=ut;
sys(2)=z1;
sys(3)=kb1;
sys(4)=x1_min;
sys(5)=x1_max;