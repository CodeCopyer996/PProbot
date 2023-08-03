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
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];

function sys=mdlOutputs(t,x,u)
c=20;
b=100;
z=c*(b-c);

alfa=z+10;     %alfa>z
beta=z-10;     %beta<z

x1=u(1);
x2=u(2);
x3=u(3);

s=c*x1+x2;
fmax=9;

if s*x1>0
   fai=alfa;
elseif s*x1<0
   fai=beta;
end

uo=x3;

M=2;
if M==1
	Kf=fmax+0.001;
	us=fai*x1+Kf*sign(s);
   ut=us;
elseif M==2
	Kf=0.1;
	us=fai*x1+Kf*sign(s);
   ut=us+uo;
end

sys(1)=ut;
sys(2)=uo;