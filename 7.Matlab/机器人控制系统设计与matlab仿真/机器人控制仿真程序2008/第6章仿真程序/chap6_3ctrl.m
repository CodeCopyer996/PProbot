function [sys,x0,str,ts]=ssss(t,x,u,flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 1,
    sys=mdlDerivatives(t,x,u);
  case 3,
    sys=mdlOutputs(t,x,u);
  case {2, 4, 9}
    sys = [];
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
global lamda1 lamda2 k

sizes = simsizes;
sizes.NumContStates  = 3+3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.15*ones(6,1)];
str=[];
ts=[];

lamda1=30;lamda2=50;k=1.5;
function sys=mdlDerivatives(t,x,u)
global lamda1 lamda2 k
r1=u(1);
dr1=2*pi*cos(2*pi*t);
r2=u(2);
dr2=2*pi*cos(2*pi*t);

yd=[r1;r2];
dyd=[dr1;dr2];

q1=u(3);q2=u(4);
dq1=u(5);dq2=u(6);
x1=[q1;q2];
x2=[dq1;dq2];

for i=1:1:3
    Fai1(i)=x(i);
end
for i=1:1:3
    Fai2(i)=x(i+3);
end

u1(1)=exp(-1/2*((x(1)+1.25)/0.6)^2);
u1(2)=exp(-1/2*(x(1)/0.6)^2);
u1(3)=exp(-1/2*((x(1)-1.25)/0.6)^2);

u2(1)=exp(-1/2*((x(2)+1.25)/0.6)^2);
u2(2)=exp(-1/2*(x(2)/0.6)^2);
u2(3)=exp(-1/2*((x(2)-1.25)/0.6)^2);

u3(1)=exp(-1/2*((x(3)+1.25)/0.6)^2);
u3(2)=exp(-1/2*(x(3)/0.6)^2);
u3(3)=exp(-1/2*((x(3)-1.25)/0.6)^2);

u4(1)=exp(-1/2*((x(4)+1.25)/0.6)^2);
u4(2)=exp(-1/2*(x(4)/0.6)^2);
u4(3)=exp(-1/2*((x(4)-1.25)/0.6)^2);

sum1=0;
for i=1:1:3
        fs1=u1(i)*u2(i)*u3(i);
        sum1=sum1+fs1;
        P1(i)=fs1/(sum1+0.01);
end
P2=P1;

y=x1;
z1=y-yd;
alfa1=-lamda1*z1+dyd;
z2=x2-alfa1;

gama=2.0;
dFai1=gama*z2(1)*P1-2*k*Fai1;
dFai2=gama*z2(2)*P2-2*k*Fai2;

for i=1:1:3
    sys(i)=dFai1(i);
end
for i=1:1:3
    sys(3+i)=dFai2(i);
end

function sys=mdlOutputs(t,x,u)
global lamda1 lamda2 k

r1=u(1);
dr1=2*pi*cos(2*pi*t);
r2=u(2);
dr2=2*pi*cos(2*pi*t);

yd=[r1;r2];
dyd=[dr1;dr2];

q1=u(3);q2=u(4);
dq1=u(5);dq2=u(6);
x1=[q1;q2];
x2=[dq1;dq2];

for i=1:1:3
    Fai1(i)=x(i);
end
for i=1:1:3
    Fai2(i)=x(i+3);
end

u1(1)=exp(-1/2*((x(1)+1.25)/0.6)^2);
u1(2)=exp(-1/2*(x(1)/0.6)^2);
u1(3)=exp(-1/2*((x(1)-1.25)/0.6)^2);

u2(1)=exp(-1/2*((x(2)+1.25)/0.6)^2);
u2(2)=exp(-1/2*(x(2)/0.6)^2);
u2(3)=exp(-1/2*((x(2)-1.25)/0.6)^2);

u3(1)=exp(-1/2*((x(3)+1.25)/0.6)^2);
u3(2)=exp(-1/2*(x(3)/0.6)^2);
u3(3)=exp(-1/2*((x(3)-1.25)/0.6)^2);

u4(1)=exp(-1/2*((x(4)+1.25)/0.6)^2);
u4(2)=exp(-1/2*(x(4)/0.6)^2);
u4(3)=exp(-1/2*((x(4)-1.25)/0.6)^2);

sum1=0;
for i=1:1:3
        fs1=u1(i)*u2(i)*u3(i)*u4(i);
        sum1=sum1+fs1;
        P1(i)=fs1/(sum1+0.001);
end
fai1=Fai1*P1';
P2=P1;
fai2=Fai2*P2';

fai=[fai1;fai2];

y=x1;
z1=y-yd;
alfa1=-lamda1*z1+dyd;
z2=x2-alfa1;
tol=-lamda2*z2-z1-fai;

sys(1)=tol(1);
sys(2)=tol(2);