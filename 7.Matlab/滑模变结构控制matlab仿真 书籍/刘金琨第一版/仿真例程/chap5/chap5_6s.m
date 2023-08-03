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
sizes = simsizes;
sizes.NumContStates  = 8;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0.2*ones(8,1)];
str = [];
ts  = [];

function sys=mdlDerivatives(t,x,u)

r=0.1*sin(pi*t);
dr=0.1*pi*cos(pi*t);
ddr=-0.1*pi*pi*sin(pi*t);

e=u(1);
de=u(2);

c=10;
s=de+c*e;

w=0.1*ones(1,4);   
v=0.1*ones(1,4);   
bi=10*ones(4,1);   
ci=10*ones(2,4);   

xx(1)=r+e;
xx(2)=dr+de;
   
for j=1:1:4
    h(j)=exp(-norm(xx'-ci(:,j))^2/(2*bi(j)*bi(j)));
end
fx1=w*h';
gx1=v*h';

w=[x(1),x(2),x(3),x(4)];
v=[x(5),x(6),x(7),x(8)];

J1=h;
J2=h*u(3);

for i=1:1:4
    sys(i)=J1(i)*s;
end
for i=5:1:8
    sys(i)=J2(i-4)*s;
end

function sys=mdlOutputs(t,x,u)

r=0.1*sin(pi*t);
dr=0.1*pi*cos(pi*t);
ddr=-0.1*pi*pi*sin(pi*t);

e=u(1);
de=u(2);

c=10;
s=de+c*e;
kesi=ddr-c*de;

M=2;
if M==1
	K=1.0;
	R=kesi-K*sign(s);
elseif M==2
	K=5;
   delta0=0.03;
   delta1=5;
   delta=delta0+delta1*abs(e);
   R=kesi-K*s/(abs(s)+delta);
end

w=0.1*ones(1,4);   
v=0.1*ones(1,4);   
bi=10*ones(4,1);   
ci=10*ones(2,4);   

xx(1)=r+e;
xx(2)=dr+de;

for j=1:1:4
    h(j)=exp(-norm(xx'-ci(:,j))^2/(2*bi(j)*bi(j)));
end
w=[x(1),x(2),x(3),x(4)];
v=[x(5),x(6),x(7),x(8)];

fx1=w*h';
gx1=v*h';

ut=(-fx1+R)/(gx1+0.002);

sys(1)=ut;
sys(2)=fx1;
sys(3)=gx1;