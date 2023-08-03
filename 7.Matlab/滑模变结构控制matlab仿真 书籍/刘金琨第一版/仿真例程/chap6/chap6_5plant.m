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
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 9;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [3;0;0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)   %Time-varying model

xe=x(1);
ye=x(2);
the=x(3);

v=u(1);
w=u(2);

vr=1.0;
wr=1.0;

sys(1)=ye*w-v+vr*cos(the);
sys(2)=-xe*w+vr*sin(the);
sys(3)=wr-w;
function sys=mdlOutputs(t,x,u)
xe=x(1);
ye=x(2);
the=x(3);

vr=1.0;
wr=1.0;
r=vr/wr;

xr=r*cos(t);
yr=r*sin(t);
thr=wr*t;

th=thr-x(3);
M1=[cos(th) sin(th);-sin(th) cos(th)];
M2=[xr;yr]-inv(M1)*[xe;ye];
xp=M2(1);
yp=M2(2);

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=xp;
sys(5)=yp;
sys(6)=th;
sys(7)=xr;
sys(8)=yr;
sys(9)=thr;