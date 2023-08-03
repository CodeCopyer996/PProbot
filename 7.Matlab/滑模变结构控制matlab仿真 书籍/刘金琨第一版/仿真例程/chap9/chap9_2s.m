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
sizes.NumOutputs     = 3;
sizes.NumInputs      = 21;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,x,u)
persistent e10 de10 dde10 ddde10 e20 de20 dde20 ddde20 e30 de30 dde30 ddde30
T=0.5;

x11d=u(1);
dx11d=pi/2*cos(pi*t/2);
ddx11d=-(pi/2)^2*sin(pi*t/2);
dddx11d=-(pi/2)^3*cos(pi*t/2);

x21d=u(2);
dx21d=-pi*sin(pi*t);
ddx21d=-pi^2*cos(pi*t);
dddx21d=pi^3*sin(pi*t);

x31d=u(3);
dx31d=0;
ddx31d=0;
dddx31d=0;

x=u(4:1:12);
dx=u(13:1:21);
if t==0
   e10=x(1);
   de10=x(2)-pi/2;
   dde10=x(3);
   ddde10=dx(3)+(pi/2)^3;   
   
	e20=x(4)-1;
	de20=x(5);
	dde20=x(6)+pi^2;
	ddde20=dx(6);
   
	e30=x(7)-1;
	de30=x(8);
	dde30=x(9);
	ddde30=dx(9);
end

C=[4 0 0 4 0 0 1 0 0;
   0 4 0 0 4 0 0 1 0;
   0 0 4 0 0 4 0 0 1];

e1=x(1)-x11d;
de1=x(2)-dx11d;
dde1=x(3)-ddx11d;
ddde1=dx(3)-dddx11d;

e2=x(4)-x21d;
de2=x(5)-dx21d;
dde2=x(6)-ddx21d;
ddde2=dx(6)-dddx21d;

e3=x(7)-x31d;
de3=x(8)-dx31d;
dde3=x(9)-ddx31d;
ddde3=dx(9)-dddx31d;

e=[e1;e2;e3];
if t<=T
   A10=35/T^4*e10+20/T^3*de10+5/T^2*dde10+2/3*1/T*ddde10;
   A11=84/T^5*e10+45/T^4*de10+10/T^3*dde10+1/T^2*ddde10;
   A12=70/T^6*e10+36/T^5*de10+15/(2*T^4)*dde10+2/(3*T^3)*ddde10;
   A13=20/T^7*e10+10/T^6*de10+2/(T^5)*dde10+1/(6*T^4)*ddde10;
   p1=e10+de10*t+1/2*dde10*t^2+1/6*ddde10*t^3-A10*t^4+A11*t^5-A12*t^6+A13*t^7;
   dp1=de10+dde10*t+1/2*ddde10*t^2-A10*4*t^3+A11*5*t^4-A12*6*t^5+A13*7*t^6;
   ddp1=dde10+ddde10*t-A10*4*3*t^2+A11*5*4*t^3-A12*6*5*t^4+A13*7*6*t^5;
   dddp1=ddde10-A10*4*3*2*t+A11*5*4*3*t^2-A12*6*5*4*t^3+A13*7*6*5*t^4;
   
   A20=35/T^4*e20+20/T^3*de20+5/T^2*dde20+2/3*1/T*ddde20;
   A21=84/T^5*e20+45/T^4*de20+10/T^3*dde20+1/T^2*ddde20;
   A22=70/T^6*e20+36/T^5*de20+15/(2*T^4)*dde20+2/(3*T^3)*ddde20;
   A23=20/T^7*e20+10/T^6*de20+2/(T^5)*dde20+1/(6*T^4)*ddde20;   
   p2=e20+de20*t+1/2*dde20*t^2+1/6*ddde20*t^3-A20*t^4+A21*t^5-A22*t^6+A23*t^7;
   dp2=de20+dde20*t+1/2*ddde20*t^2-A20*4*t^3+A21*5*t^4-A22*6*t^5+A23*7*t^6;
   ddp2=dde20+ddde20*t-A20*4*3*t^2+A21*5*4*t^3-A22*6*5*t^4+A23*7*6*t^5;
   dddp2=ddde20-A20*4*3*2*t+A21*5*4*3*t^2-A22*6*5*4*t^3+A23*7*6*5*t^4;
   
   A30=35/T^4*e30+20/T^3*de30+5/T^2*dde30+2/3*1/T*ddde30;
   A31=84/T^5*e30+45/T^4*de30+10/T^3*dde30+1/T^2*ddde30;
   A32=70/T^6*e30+36/T^5*de30+15/(2*T^4)*dde30+2/(3*T^3)*ddde30;
   A33=(20/T^7*e30+10/T^6*de30+2/(T^5)*dde30+1/(6*T^4)*ddde30);
   p3=e30+de30*t+1/2*dde30*t^2+1/6*ddde30*t^3-A30*t^4+A31*t^5-A32*t^6+A33*t^7;
   dp3=de30+dde30*t+1/2*ddde30*t^2-A30*4*t^3+A31*5*t^4-A32*6*t^5+A33*7*t^6;
   ddp3=dde30+ddde30*t-A30*4*3*t^2+A31*5*4*t^3-A32*6*5*t^4+A33*7*6*t^5;
   dddp3=ddde30-A30*4*3*2*t+A31*5*4*3*t^2-A32*6*5*4*t^3+A33*7*6*5*t^4;
else
   p1=0;p2=0;p3=0;
   dp1=0;dp2=0;dp3=0;
   ddp1=0;ddp2=0;ddp3=0;
   dddp1=0;dddp2=0;dddp3=0;
end

f=[-1.5*x(3)^2*cos(3*x(4)),3*x(5)*sin(x(7)),x(9)*cos(x(1))*sin(x(4))];
u1=f(1)-dddx11d-dddp1+4*(x(2)-dx11d-dp1)+4*(x(3)-ddx11d-ddp1);
u2=f(2)-dddx21d-dddp2+4*(x(5)-dx21d-dp2)+4*(x(6)-ddx21d-ddp2);
u3=f(3)-dddx31d-dddp3+4*(x(8)-dx31d-dp3)+4*(x(9)-ddx31d-ddp3);

rou1=dde1+4*de1+4*e1-ddp1-4*dp1-4*p1;
rou2=dde2+4*de2+4*e2-ddp2-4*dp2-4*p2;
rou3=dde3+4*de3+4*e3-ddp3-4*dp3-4*p3;
rou=[rou1;rou2;rou3];

delta0=0.03;
delta1=5;
delta=delta0+delta1*norm(e);
mrou=norm(rou)+delta;

K=10;
F=2+exp(-t);
ut=-[u1;u2;u3]-rou/mrou*(F+K);

sys(1)=ut(1);
sys(2)=ut(2);
sys(3)=ut(3);