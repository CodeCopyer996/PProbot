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
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,x,u)
J=0.6;Ce=1.2;Km=6;
Ku=11;R=7.77;

r=0.1*sin(2*pi*t);
dr=0.1*2*pi*cos(2*pi*t);
ddr=-0.1*(2*pi)^2*sin(2*pi*t);

e=u(1);
de=u(2);
Ff=u(3);
x2=dr-de;

c=30;
eq=10;
k=5.0;
s=de+c*e;

M=1;
if M==1        %PD
   ut=150*e+5*de;  
elseif M==2    %SMC
   ut=J*R/(Ku*Km)*(c*de+ddr+eq*sign(s)+k*s+Km*Ce/(J*R)*x2+Ff/J);
end

sys(1)=ut;