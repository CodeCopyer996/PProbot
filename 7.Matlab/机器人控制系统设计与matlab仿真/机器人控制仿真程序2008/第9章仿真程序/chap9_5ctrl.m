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
sizes.NumOutputs     = 1;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
r=u(1);
dr=cos(t);
ddr=-sin(t);
th=u(2);
dth=u(3);
fp=u(5);

e=r-th;
de=dr-dth;
c=3;
s=de+c*e;

b=15;
a=5;

M=2;
if M==1       % Traditional with SMC
    Kf=6;
%    Kf=0.15;
    ut=1/a*(c*de+ddr+b*dth+Kf*sign(s));
elseif M==2   % SMC with observer
    Kf=0.15;
    ut=1/a*(c*de+ddr+b*dth+1*fp+Kf*sign(s));
end
sys(1)=ut;