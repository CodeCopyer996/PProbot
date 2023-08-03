function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[-1 0];
function sys=mdlOutputs(t,x,u)
x1=u(1);
x2=u(2);
x2d=u(3);
x2_bar=u(4);
z2=x2-x2d;

c2=45;
tol2=0.01;

dx2d=(x2_bar-x2d)/tol2;

I=1.0;J=1.0;Mgl=5.0;K=40;
f1=-sin(x1);
f2=-x1;
b1=K/I;
b2=Mgl/I;
b3=1/J;
b4=K/J;

x3_bar=1/b1*(-b2*f1+dx2d-c2*z2)-f2;

sys(1)=x3_bar;