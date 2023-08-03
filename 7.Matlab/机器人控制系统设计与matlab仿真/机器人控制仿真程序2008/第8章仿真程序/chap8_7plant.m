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
global M
M=2;
sizes = simsizes;
sizes.NumContStates  = 6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 8;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
if M==1
    x0=[0.3,-0.2,0.2,0,0,0];
elseif M==2
    x0=zeros(1,6);
end
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
global M
%Double Link Inverted Pendulum Parameters
A=[0,0,0,1.0,0,0;
   0,0,0,0,1.0,0;
   0,0,0,0,0,-1.0;
   0,-3.7864,0.2009,-4.5480,0.0037,-0.0017;
   0,41.9965,9.3378,7.6261,-0.0570,0.0349;
   0,-25.0347,-29.5778,1.0850,0.0675,-0.0543];
B1=[0;0;0;-1.1902;-55.3119;175.2019];
B2=[0;0;0;68.6019;-115.0316;-16.3660];

ut=u(1);
if M==1
   w=0;
elseif M==2
   w=sin(0.1*t)/(t+1);
end

S=A*x+B1*w'+B2*ut;
for i=1:6
    sys(i)=S(i);
end
function sys=mdlOutputs(t,x,u)
global M

if M==1
   w=0;
elseif M==2
   w=sin(0.1*t)/(t+1);
end
q1=1.69;q2=2;q3=0.01;q4=0.3;q5=0.1;q6=0.01;
rho=1;

z=[q1*x(1) q2*x(2) q3*x(3) q4*x(4) q5*x(5) q6*x(6) rho*u(1)]';

zp=z'*z;
wp=w'*w;

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);
sys(5)=x(5);
sys(6)=x(6);
sys(7)=zp;
sys(8)=wp;