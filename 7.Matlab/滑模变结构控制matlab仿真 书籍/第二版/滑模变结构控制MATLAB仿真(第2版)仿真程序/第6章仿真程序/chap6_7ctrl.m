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
sizes.NumInputs      = 7;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[-1 0];
function sys=mdlOutputs(t,x,u)
x1d=u(1);
x4d=u(2);
x4_bar=u(3);

x1=u(4);
x2=u(5);
x3=u(6);
x4=u(7);

I=1.0;J=1.0;Mgl=5.0;K=40;
f1=-sin(x1);
f2=-x1;
f3=x1-x3;
b1=K/I;
b2=Mgl/I;
b3=1/J;
b4=K/J;

tol4=0.01;

z4=x4-x4d;
dx4d=(x4_bar-x4d)/tol4;

c4=5;
D=100;
xite=D+0.10;
%xite=0;

M=2;
if M==1
    ut=1/b3*(-xite*sign(z4)-b4*f3+dx4d-c4*z4);
elseif M==2
    fai=0.20;
if abs(z4)<=fai
    sat=z4/fai;
else
    sat=sign(z4);
end   
    ut=1/b3*(-xite*sat-b4*f3+dx4d-c4*z4);
end

sys(1)=ut;