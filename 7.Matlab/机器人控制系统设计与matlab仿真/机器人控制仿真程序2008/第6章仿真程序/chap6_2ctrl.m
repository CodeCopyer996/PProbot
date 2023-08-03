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
global nmn1 nmn2 nmn3 k1 k2 k3 r1 r2 r3

sizes = simsizes;
sizes.NumContStates  = 27;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0.15*ones(27,1)];
str = [];
ts  = [];

B=0.015;L=0.0008;D=0.05;R=0.075;m=0.01;J=0.05;l=0.6;Kb=0.085;M=0.05;Kt=1;g=9.8;
Mt=J+1/3*m*l^2+1/10*M*l^2*D;

b1=1;b2=Kt/Mt;b3=1/L;
%rou=0.1;
rou=0.05;
nmn1=1/2+1/(2*rou^2*b1^2)+2.0;
nmn2=1/2+1/(2*rou^2*b2^2)+2.0;
nmn3=1/2+1/(2*rou^2*b3^2)+2.0;

k1=1.5;k2=1.5;k3=1.5;
r1=2;r2=2;r3=2;

function sys=mdlDerivatives(t,x,u)
global nmn1 nmn2 nmn3 k1 k2 k3 r1 r2 r3

yd=u(1);dyd=u(2);
x1=u(3);x2=u(4);x3=u(5);

for i=1:1:9
    Fai1(i)=x(i);
end
for i=1:1:9
    Fai2(i)=x(i+9);
end
for i=1:1:9
    Fai3(i)=x(i+18);
end

for l1=1:1:9
    gs1=-0.5*(x1+2-(l1-1)*0.5)^2;
end
u1(l1)=exp(gs1);

for l2=1:1:9
    gs2=-0.5*(x2+2-(l1-1)*0.5)^2;
end
u2(l2)=exp(gs2);

for l3=1:1:9
    gs3=-0.5*(x3+2-(l3-1)*0.5)^2;
end
u3(l3)=exp(gs3);

sum1=0;
for j=1:1:9
   sum1=sum1+u1(j);
   P1(j)=u1(j)/(sum1+0.01);
end

sum2=0;
for j=1:1:9
   sum2=sum2+u1(j)*u2(j);
   P2(j)=u1(j)*u2(j)/(sum2+0.01);
end

sum3=0;
for j=1:1:9
   sum3=sum3+u1(j)*u2(j)*u3(j);
   P3(j)=u1(j)*u2(j)*u3(j)/(sum3+0.01);
end

alfa1=-nmn1*(x1-yd)+dyd;
alfa2=-nmn2*(x2-alfa1)-(x1-yd)-Fai2*P2';

e1=x1-yd;
e2=x2-alfa1;
e3=x3-alfa2;

for j=1:1:9
    sys(j)=r1*e1*P1(j)-2*k1*x(j);
end
for j=10:1:18
    sys(j)=r2*e2*P2(j-9)-2*k2*x(j);
end
for j=19:1:27
    sys(j)=r3*e3*P3(j-18)-2*k3*x(j);
end

function sys=mdlOutputs(t,x,u)
global nmn1 nmn2 nmn3 k1 k2 k3 r1 r2 r3

yd=u(1);
dyd=u(2);
x1=u(3);
x2=u(4);
x3=u(5);

for i=1:1:9
    Fai1(i)=x(i);
end
for i=1:1:9
    Fai2(i)=x(i+9);
end
for i=1:1:9
    Fai3(i)=x(i+18);
end

for l1=1:1:9
    gs1=-0.5*(x1+2-(l1-1)*0.5)^2;
end
u1(l1)=exp(gs1);

for l2=1:1:9
    gs2=-0.5*(x2+2-(l1-1)*0.5)^2;
end
u2(l2)=exp(gs2);

for l3=1:1:9
    gs3=-0.5*(x3+2-(l3-1)*0.5)^2;
end
u3(l3)=exp(gs3);

sum1=0;
for j=1:1:9
   sum1=sum1+u1(j);
   P1(j)=u1(j)/(sum1+0.01);
end

sum2=0;
for j=1:1:9
   sum2=sum2+u1(j)*u2(j);
   P2(j)=u1(j)*u2(j)/(sum2+0.01);
end

sum3=0;
for j=1:1:9
   sum3=sum3+u1(j)*u2(j)*u3(j);
   P3(j)=u1(j)*u2(j)*u3(j)/(sum3+0.01);
end

alfa1=-nmn1*(x1-yd)+dyd;
alfa2=-nmn2*(x2-alfa1)-(x1-yd)-Fai2*P2';
ut=-nmn3*(x3-alfa2)-(x2-alfa1)-Fai3*P3';

sys(1)=ut;