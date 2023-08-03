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
global p2 p3
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0; 
sys = simsizes(sizes);
x0  = [0,0,0];
str = [];
ts  = [];

a1=20;a0=30;b=50;
Am=[0,1;-a0,-a1];
%eig(Am)
Q=[15,0;0,15];

P=lyap(Am',Q);
p2=P(1,2);
p3=P(2,2);
function sys=mdlDerivatives(t,x,u)
global p2 p3
r=sign(sin(0.025*2*pi*t)); %Square Signal

thm=u(1);
dthm=u(2);
th=u(3);
dth=u(4);

e=thm-th;
de=dthm-dth;
ep=p2*e+p3*de;

lambda0=1.5;lambda1=1.5;lambda2=1.5;
sys(1)=lambda0*ep*r;      %dk0
sys(2)=lambda1*ep*th;     %dk1
sys(3)=lambda2*ep*dth;    %dk2
function sys=mdlOutputs(t,x,u)
global p2 p3
thm=u(1);
dthm=u(2);
th=u(3);
dth=u(4);

e=thm-th;
de=dthm-dth;
ep=p2*e+p3*de;

r=sign(sin(0.025*2*pi*t));    %Square Signal
k0=x(1);k1=x(2);k2=x(3);
Fmax=1.0;

delta=0.1;
kk=1/delta;
if abs(ep)>delta
   sats=sign(ep);
else
   sats=kk*ep;
end

%v=Fmax*sign(ep);
v=Fmax*sats;
ut=k0*r+k1*th+k2*dth+v;
sys(1)=ut;