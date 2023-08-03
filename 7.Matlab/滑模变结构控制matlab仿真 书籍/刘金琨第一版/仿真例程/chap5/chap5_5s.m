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
global M ci bi c
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0.1*ones(3,1)];
str = [];
ts  = [];

function sys=mdlDerivatives(t,x,u)
persistent w m b
if t==0
	m =[-0.1693    0.7487    0.5359;
		 -0.3900   -0.9700    0.9417];
   b=0.20*ones(3,1);
end

c=30;
m0=1/133;
 
r=sin(pi*t);
dr=pi*cos(pi*t);
ddr=-pi^2*sin(pi*t);

e=u(1);
de=u(2);
x1=r+e;
x2=dr+de;
s=c*e+de;

xi=[x1;x2];
for j=1:1:3
    h(j)=exp(-norm(xi-m(:,j))^2/(2*b(j)*b(j)));
end

eq0=0.002;
eq1=0.001;
xite=m0^(-1)*(eq0-eq1);
for i=1:1:3
    sys(i)=xite*abs(s*1/m0)*h(i);
end
 
function sys=mdlOutputs(t,x,u)
persistent w m b
if t==0
%  m=1*rands(2,3)
	m =[-0.1693    0.7487    0.5359;
		 -0.3900   -0.9700    0.9417];
   b=0.20*ones(3,1);
end
w=[x(1);x(2);x(3)];

c=30;
k1=100;   %Pole placement
k2=200;

r=sin(pi*t);
dr=pi*cos(pi*t);
ddr=-pi^2*sin(pi*t);

m0=1/133;
 
e=u(1);
de=u(2);
s=c*e+de;

x1=r+e;
x2=dr+de;
xi=[x1;x2];
for j=1:1:3
    h(j)=exp(-norm(xi-m(:,j))^2/(2*b(j)*b(j)));
end

M=2;
switch M
case 1        %Konwn UP
   Up=0.5/133+0.10;   
case 2        %Using RBF
   Up=w'*h';
end

if s~=0
   u0=-m0*(c*de+k1*e+k2*de)-Up*sign(s);
else
   u0=0;
end
hn=25/133*x2;
u1=m0*(k1*e+k2*de+ddr)+hn;
ut=u1+u0;
        
sys(1)=ut;
sys(2)=Up;