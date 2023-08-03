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
x1=u(1);
dx1=u(2);
ddx1=u(3);
ut=u(4);

r=0.5*sin(pi*t);
dr=0.5*pi*cos(pi*t);
ddr=-0.5*pi^2*sin(pi*t);
   
R=[r;dr];
dR=[dr;ddr];

C=-[2000 10];
D=0.5;

xx=[x1;dx1];
s=C*R-C*xx+D*ut;

dxx=[dx1;ddx1];
xite=15;
du=1/D*(-C*dR+C*dxx-xite*sign(s));

sys(1)=r;
sys(2)=du;