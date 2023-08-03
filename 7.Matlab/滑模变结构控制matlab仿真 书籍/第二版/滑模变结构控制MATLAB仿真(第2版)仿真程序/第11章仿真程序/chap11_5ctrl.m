function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
q1d = sin(pi*t);
dq1d = pi*cos(pi*t);
ddq1d = -pi^2*sin(pi*t);
dddq1d = -pi^3*cos(pi*t);

q2d = cos(pi*t);
dq2d = -pi*sin(pi*t);
ddq2d = -pi^2*cos(pi*t);
dddq2d = pi^3*sin(pi*t);

ddqd=[ddq1d;ddq2d];
dddqd=[dddq1d;dddq2d];

x = [u(3);u(4);u(5);u(6)];
dx = [u(7);u(8);u(9);u(10)];

e1=x(1)-q1d;
de1=x(2)-dq1d;
dde1=dx(2)-ddq1d;

e2=x(3)-q2d;
de2=x(4)-dq2d;
dde2=dx(4)-ddq2d;

e=[e1;e2];
de=[de1;de2];
dde=[dde1;dde2];

n1=[5 0;0 5];
n2=[50 0;0 50];
n=[25 0;0 25];

s=dde+n1*de+n2*e;

g=9.8;

M11=0.1+0.01*cos(x(3));
M12=0.01*sin(x(3));
M21=M12;
M22=0.1;
M=[M11 M12;M21 M22];

dM11=-0.01*sin(x(3))*x(4);
dM12=0.01*cos(x(3))*x(4);
dM21=dM12;
dM22=0;
dM=[dM11 dM12;dM21 dM22];

C11=-0.01*sin(x(3))*x(4)/2;
C12=0.01*cos(x(3))*x(4)/2;
C21=C12;
C22=0;
C=[C11 C12;C21 C22];

dC11=-0.01*(cos(x(3))*x(4)*x(4)+sin(x(3))*x(4)*dx(4))/2;
dC12=-0.01*(-sin(x(3))*x(4)*x(4)+cos(x(3))*dx(4))/2;
dC21=dC12;
dC22=0;
dC=[dC11 dC12;dC21 dC22];

G1=0.01*g*cos(x(1)+x(3));
G2=0.01*g*cos(x(1)+x(3));
G=[G1;G2];
dG1=-0.01*g*sin(x(1)+x(3))*(x(2)+x(4));
dG2=-0.01*g*sin(x(1)+x(3))*(x(2)+x(4));
dG=[dG1;dG2];

H0=M*(n1*dde+n2*de-dddqd)+C*(n1*de+n2*e-ddqd)-(dM+n*M)*[dx(2);dx(4)]-(dC+n*C)*[x(2);x(4)]-(dG+n*G);

xite=[6 0;0 5];
ut=-inv(n)*(H0+xite*sign(s));

sys(1)=ut(1);
sys(2)=ut(2);