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
sizes.NumOutputs     = 1;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];

function sys=mdlOutputs(t,x,u)
r=sin(2*pi*t);    
dr=2*pi*cos(2*pi*t);
ddr=-(2*pi)^2*sin(2*pi*t);

x1=u(1);
x2=u(2);

a=5.0;
fx=3*x2;

c=5;
s=c*x1+x2;

F=3.0;
D=10;
xite=10;
kx=F+D+xite;

M=1;
if M==1           %Switch function
   ut=1/a*(-fx-c*x2-kx*sign(s));
elseif M==2       %Saturated function
   fai=0.20;
   if abs(s)<=fai
      sat=s/fai;
   else
      sat=sign(s);
   end
   ut=1/a*(-fx-c*x2-kx*sat);
elseif M==3       %Relay function
   delta=0.001;
   rs=s/(abs(s)+delta);
   ut=1/a*(-fx-c*x2-kx*rs);
end
        
sys(1)=ut;