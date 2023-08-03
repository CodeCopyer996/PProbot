function [sys,x0,str,ts] = model(t,x,u,flag)
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
global M1 B1 nmn
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0.1*ones(2,1)];
str = [];
ts  = [];

nmn=50;
g=9.8;m=1;l=0.25;
M=4/3*m*l^2;B=2.0;  %Practical model
M1=0.3*M;B1=0.3*B;  %Norminal model
function sys=mdlDerivatives(t,x,u)
global M1 B1 nmn

qd=sin(pi*t);
dqd=pi*cos(pi*t);
ddqd=-pi*pi*sin(pi*t);

e=u(1);
de=u(2);
dq=u(3);
ddq=u(4);

r=de+nmn*e;
Y=[ddq dq];

k=30;
dup=-k*Y*r;
sys(1)=dup(1);
sys(2)=dup(2);
function sys=mdlOutputs(t,x,u)
global M1 B1 nmn
qd=sin(pi*t);
dqd=pi*cos(pi*t);
ddqd=-pi*pi*sin(pi*t);
e=u(1);
de=u(2);
dq=u(3);
ddq=u(4);

r=de+nmn*e;
a=ddqd-2*nmn*de-nmn^2*e;

tol0=M1*a+B1*dq;
Y=[ddq dq];
up=[x(1);x(2)];
rou=2.5;
ur=-rou*sign(r);

tol=tol0+Y*up+ur;

sys(1)=tol;
sys(2)=tol0;
sys(3)=Y*up;
sys(4)=ur;