%S-function for continuous state equation
function [sys,x0,str,ts]=s_function(t,x,u,flag)

switch flag,
%Initialization
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
%Outputs
  case 3,
    sys=mdlOutputs(t,x,u);
%Unhandled flags
  case {2, 4, 9 }
    sys = [];
%Unexpected flags
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

%mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
x=u;

bx=1.0;
fx=0.1*sin(20*t);
gx=0.12*sin(t);

lg=0.015;
beta=1.0;
xite=0.20;

q=3;p=5;

M=1;
if M==1       %TSM
   T1=abs(x(1))^(q/p)*sign(x(1));   
   T2=abs(x(1))^(q/p-1)*sign(x(1));
   
   s=x(2)+beta*T1;   
   ut=-inv(bx)*(fx+beta*q/p*T2*x(2)+(lg+xite)*sign(s));
elseif M==2   %NTSM
   T1=abs(x(2))^(p/q)*sign(x(2));
   T2=abs(x(2))^(2-p/q)*sign(x(2));
   s=x(1)+1/beta*T1;
  	ut=-inv(bx)*(fx+beta*q/p*T2+(lg+xite)*sign(s));
end

sys(1)=ut;