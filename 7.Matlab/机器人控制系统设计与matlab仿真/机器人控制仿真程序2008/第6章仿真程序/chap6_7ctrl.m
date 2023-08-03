function [sys,x0,str,ts] =s_model(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
global gr k k1 k2 k3 nmn
global c b node v
gr=4;k=8.45;
k1=9;k2=9;k3=6;
nmn=4.5;

c=[ -2 -2  -2;
    -1 -1  -1;
  -0.5 -0.5 -0.5;    
    0   0   0;
   0.5 0.5 0.5;    
    1   1   1;
    2   2   2];
b=1.5;
node=7;

sizes = simsizes;
sizes.NumContStates  = 3*node;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = rand(1,3*node);
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global gr k k1 k2 k3 nmn
global c b node v
q2d=u(1);
dq2d=cos(t);

q1=u(2);dq1=u(3);
q2=u(4);dq2=u(5);

e=q2d-q2;
de=dq2d-dq2;
r=de+nmn*e;

z=q2-1/gr*q1;
dz=dq2-1/gr*dq1;

xi=[r z dz]';

for j=1:1:node
   h(j)=exp(-norm(xi-c(j,:)')^2/(2*b*b));
end
W1=[x(1:node)]';
W2=[x(node+1:node*2)]';
W3=[x(node*2+1:node*3)]';

F1=W1*h';
F2=W2*h';

zd=-1/k*(F1+k1*r);
xite1=zd-z;
u1=F2+k2*xite1-k*r;
xite2=u1-dz;

Kexi=[r xite1 xite2]';

m=0.01;
Gama1=0.01;Gama2=0.01;Gama3=0.01;

for i=1:1:node
    sys(i)=Gama1*h(i)*r-m*Gama1*norm(Kexi)*W1(i);
    sys(i+node)=Gama2*h(i)*xite1-m*Gama2*norm(Kexi)*W2(i);
    sys(i+node*2)=Gama3*h(i)*xite2-m*Gama3*norm(Kexi)*W3(i);
end

function sys=mdlOutputs(t,x,u)
global gr k k1 k2 k3 nmn
global c b node v

q2d=u(1);
dq2d=cos(t);

q1=u(2);dq1=u(3);
q2=u(4);dq2=u(5);

e=q2d-q2;
de=dq2d-dq2;
r=de+nmn*e;

z=q2-1/gr*q1;
dz=dq2-1/gr*dq1;

xi=[r z dz]';

for j=1:1:node
    h(j)=exp(-norm(xi-c(j,:)')^2/(2*b*b));
end

W1=[x(1:node)]';
W2=[x(node+1:node*2)]';
W3=[x(node*2+1:node*3)]';

F1=W1*h';
F2=W2*h';
F3=W3*h';

zd=-1/k*(F1+k1*r);
xite1=zd-z;
u1=F2+k2*xite1-k*r;
xite2=u1-dz;
Td=-F3-k3*xite2-xite1;

sys(1)=Td;
sys(2)=h(1);
sys(3)=h(2);
sys(4)=h(3);
sys(5)=h(4);
sys(6)=h(5);