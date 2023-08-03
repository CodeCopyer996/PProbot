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
global p2 p3
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0; 
sys = simsizes(sizes);
x0  = [0,0,0];
str = [];
ts  = [];

a1=20;a0=30;b=50;
Am=[0,1;-a0,-a1];
%eig(Am)
Q=[15,0;0,15];

P=lyap(Am',Q);
p2=P(1,2);
p3=P(2,2);
function sys=mdlDerivatives(t,x,u)
global p2 p3
r=sign(sin(0.025*2*pi*t)); %Square Signal

e=u(1)-u(3);
de=u(2)-u(4);
ep=p2*e+p3*de;

n0=5;n1=5;n2=5;
sys(1)=n0*ep*r;       %dk0
sys(2)=n1*ep*u(3);    %dk1
sys(3)=n2*ep*u(4);    %dk2
function sys=mdlOutputs(t,x,u)
global p2 p3
Fs_U=1.0;
Fc_U=0.5; 
Dv=0.02;

e=u(1)-u(3);
de=u(2)-u(4);
ep=p2*e+p3*de;

beta0_L=10;
beta1_U=1.0;
if abs(u(3))<=Dv
   q=beta1_U*Fs_U*sign(ep)/beta0_L;
else
   q=beta1_U*Fc_U*sign(ep)/beta0_L;
end
r=sign(sin(0.025*2*pi*t));    %Square Signal

ut=x(1)*r+x(2)*u(3)+x(3)*u(4)+q;
sys(1)=ut;