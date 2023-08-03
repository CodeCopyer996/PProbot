function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      =5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys=simsizes(sizes);

x0=[0 0 0 0];
str=[];
ts=[-1 0];
function sys=mdlDerivatives(t,x,u)
x1=u(1);
w2=u(2);
psi12=u(3);
psi22=u(4);
psi32=u(5);

x1d=sin(t);
dx1d=cos(t);
s1=x1-x1d;
l1=45;
phi=[l1*s1+w2-dx1d; psi12; psi22; psi32];

eta=0.00001;
gam=diag([0.006 200 20 420]);

dth=gam*s1*phi-gam*eta*x;

sys(1)=dth(1);
sys(2)=dth(2);
sys(3)=dth(3);
sys(4)=dth(4);
function sys=mdlOutputs(t,x,u)
x1=u(1);
w2=u(2);
psi12=u(3);
psi22=u(4);
psi32=u(5);
th=x;
x1d=sin(t);
dx1d=cos(t);
s1=x1-x1d;
l1=45;
phi=[l1*s1+w2-dx1d; psi12; psi22; psi32];
v2_bar=-th'*phi;

sys(1)=v2_bar;
sys(2)=x(1);
sys(3)=x(2);
sys(4)=x(3);
sys(5)=x(4);