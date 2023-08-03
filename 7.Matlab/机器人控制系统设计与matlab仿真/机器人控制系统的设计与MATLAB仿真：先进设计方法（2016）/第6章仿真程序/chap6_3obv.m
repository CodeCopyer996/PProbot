function [sys,x0,str,ts] = obv(t,x,u,flag)
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
sizes.NumContStates  = 20;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = zeros(20,1);
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
ut=u(1);
z1=u(2);

I=1.0;J=1.0;Mgl=5.0;K=40;
a1=-(K/I+K/J);
a2=-Mgl/I;
a3=-K*Mgl/(I*J);
b0=K/(I*J);

A=[0 1 0 0;
   0 0 1 0;
   0 0 0 1;
   0 0 0 0];
b=[0 0 0 b0];
c=[1 0 0 0];

f1=[0 z1 0 0]';
f2=[0 sin(z1) 0 0]';
f3=[0 0 0 sin(z1)]';

a=1.5;
k1=4*a;
k2=6*a^2;
k3=4*a^3;
k4=a^4;
k=[k1 k2 k3 k4]';   
A0=A-k*c;
%eig(A0);

e4=[0 0 0 1]';
w=[x(1) x(2) x(3) x(4)]';
Fai1=[x(5) x(6) x(7) x(8)]';
Fai2=[x(9) x(10) x(11) x(12)]';
Fai3=[x(13) x(14) x(15) x(16)]';
v=[x(17) x(18) x(19) x(20)]';


for i=1:1:4
    D1=A0*w+k*z1;
    sys(i)=D1(i);
end
for i=1:1:4
    D2=A0*Fai1+f1;
    sys(i+4)=D2(i);
end
for i=1:1:4
    D3=A0*Fai2+f2;
    sys(i+8)=D3(i);
end
for i=1:1:4
    D4=A0*Fai3+f3;
    sys(i+12)=D4(i);
end
for i=1:1:4
    dv=A0*v+e4*ut;
    sys(i+16)=dv(i);
end

function sys=mdlOutputs(t,x,u)
I=1.0;J=1.0;Mgl=5.0;K=40;
a1=-(K/I+K/J);
a2=-Mgl/I;
a3=-K*Mgl/(I*J);
b0=K/(I*J);

w=[x(1) x(2) x(3) x(4)]';
Fai1=[x(5) x(6) x(7) x(8)]';
Fai2=[x(9) x(10) x(11) x(12)]';
Fai3=[x(13) x(14) x(15) x(16)]';
v=[x(17) x(18) x(19) x(20)]';

z=w+a1*Fai1+a2*Fai2+a3*Fai3+b0*v;

sys(1)=z(1);
sys(2)=z(2);
sys(3)=z(3);
sys(4)=z(4);