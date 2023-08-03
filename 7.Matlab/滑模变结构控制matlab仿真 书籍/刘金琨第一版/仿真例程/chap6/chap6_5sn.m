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

k1=10;
k2=10;

q(2)=wr+k2*sign(te);
w=q(2);
q(1)=vr*cos(te)+k1*xe+ye/(xe+0.01)*vr*sin(te);

sys(1)=q(1);
sys(2)=q(2);