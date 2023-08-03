function [sys,x0,str,ts] = MIMO_Tong_s(t,x,u,flag)
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
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0 =[];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
yd1=u(1);
yd2=u(2);
dyd1=cos(t);
dyd2=cos(t);
ddyd1=-sin(t);
ddyd2=-sin(t);

x1=u(3);x2=u(4);
x3=u(5);x4=u(6);

e1=yd1-x1;
e2=yd2-x3;
de1=dyd1-x2;
de2=dyd2-x4;

nmn1=20;nmn2=20;
beta11=nmn1;beta21=nmn2;
K0=15*eye(2);

v1=ddyd1+beta11*de1;
v2=ddyd2+beta21*de2;
v=[v1 v2]';

s1=de1+nmn1*e1;
s2=de2+nmn2*e2;
s=[s1 s2]';

m1=1;me=2;
l1=1;
lc1=0.5;
lce=0.6;
I1=0.12;
Ie=0.25;
Qe=30*pi/180;

a1=I1+m1*lc1^2+Ie+me*lce^2+me*l1^2;
a2=Ie+me*lce^2;
a3=me*l1*lce*cos(Qe);
a4=me*l1*lce*sin(Qe);

M11=a1+2*a3*cos(x3)+2*a4*sin(x3);
M22=a2;
M21=a2+a3*cos(x3)+a4*sin(x3);
M12=M21;
M=[M11 M12;M21 M22];

h=a3*sin(x3)-a4*cos(x3);

F=-inv(M)*[-h*x4 -h*(x2+x4);h*x2 0]*[x2;x4];
G=inv(M);

%Control law (8)
ut=inv(G)*(-F+v+K0*s);

sys(1)=ut(1);
sys(2)=ut(2);