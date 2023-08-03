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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,x,u)
m=1.65;
l=0.28;
D=0.01;
I=1/3*m*l^2;
G=0.52920;

A=[0 1;0 -D/I];
B=[0;G/I];

x=[u(1);u(2)];

C=[5 1];
rou=C*x;

M=1;   %Used method
if M==1        %SVSS
   K=abs(inv(C*B)*C*A*x)+1.0;
   ut=-K*sign(rou);
elseif M==2    %EVSS
   Ke=1.0;
   ueq=-inv(C*B)*C*A*x;
   ud=-Ke*sign(rou);   
   ut=ueq+ud;
elseif M==3    %IVSS
   Ki=1.0;
   ueq=-inv(C*B)*C*A*x;
   ud=-Ki*abs(u(3))*sign(rou);
   ut=ueq+ud;
elseif M==4    %WIVSS
   Kw=5;
   Kf=-5;
   p=u(3);
   z=Kf*p+rou;
   ueq=-inv(C*B)*C*A*x;
   ud=-Kw*abs(p)*sign(rou);
   ut=ueq+ud;
end   

sys(1)=ut;
sys(2)=rou;
if M==4
	sys(2)=z;
end