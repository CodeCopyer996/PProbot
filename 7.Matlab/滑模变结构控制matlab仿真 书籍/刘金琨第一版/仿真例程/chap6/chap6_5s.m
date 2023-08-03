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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 9;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,x,u)
vr=1.0;
wr=1.0;

xe=u(1);
ye=u(2);
te=u(3);

delta1=0.02;
delta2=0.02;
k1=6.0;
k2=6.0;
s1=xe;
s2=te+atan(vr*ye);

Q=vr/(1+vr^2*ye^2);
q(2)=(wr+Q*vr*sin(te)+k2*s2/(abs(s2)+delta2))/(1+Q*xe);
w=q(2);
q(1)=ye*w+vr*cos(te)+k1*s1/(abs(s1)+delta1);

sys(1)=q(1);
sys(2)=q(2);