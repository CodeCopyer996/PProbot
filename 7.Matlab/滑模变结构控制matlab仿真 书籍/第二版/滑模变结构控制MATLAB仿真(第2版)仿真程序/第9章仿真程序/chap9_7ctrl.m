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
global node c b Fai
node=5;
c=0.1*[-1 -0.5 0 0.5 1;
       -1 -0.5 0 0.5 1;
       -1 -0.5 0 0.5 1;
       -1 -0.5 0 0.5 1;
       -1 -0.5 0 0.5 1];
b=0.50;
Fai=50*eye(2);

sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global node c b Fai
qd1=u(1);
d_qd1=u(2);
dd_qd1=u(3);
qd2=u(4);
d_qd2=u(5);
dd_qd2=u(6);

q1=u(7);
d_q1=u(8);
q2=u(9);
d_q2=u(10);

e1=qd1-q1;
e2=qd2-q2;
de1=d_qd1-d_q1;
de2=d_qd2-d_q2;
e=[e1;e2];
de=[de1;de2];
r=de+Fai*e;

qd=[qd1;qd2];
dqd=[d_qd1;d_qd2];
ddqd=[dd_qd1;dd_qd2];

z1=[e(1);de(1);qd(1);dqd(1);ddqd(1)];
z2=[e(2);de(2);qd(2);dqd(2);ddqd(2)];

h1=zeros(7,1);
h2=zeros(7,1);
for j=1:1:node
    h1(j)=exp(-norm(z1-c(:,j))^2/(b*b));
    h2(j)=exp(-norm(z2-c(:,j))^2/(b*b));
end

gama=500;miu=100;
k=2*miu/gama;

sumi=(r(1))^2*norm(h1)^2+(r(2))^2*norm(h2)^2;
sys(1)=gama/2*sumi-k*gama*x(1);
function sys=mdlOutputs(t,x,u)
global node c b Fai
qd1=u(1);
d_qd1=u(2);
dd_qd1=u(3);
qd2=u(4);
d_qd2=u(5);
dd_qd2=u(6);

q1=u(7);
d_q1=u(8);
q2=u(9);
d_q2=u(10);

q=[q1;q2];

e1=qd1-q1;
e2=qd2-q2;
de1=d_qd1-d_q1;
de2=d_qd2-d_q2;
e=[e1;e2];
de=[de1;de2];
r=de+Fai*e;

qd=[qd1;qd2];
dqd=[d_qd1;d_qd2];
ddqd=[dd_qd1;dd_qd2];
faip=x(1);

z1=[e(1);de(1);qd(1);dqd(1);ddqd(1)];
z2=[e(2);de(2);qd(2);dqd(2);ddqd(2)];
h1=zeros(7,1);
h2=zeros(7,1);
for j=1:1:node
    h1(j)=exp(-norm(z1-c(:,j))^2/(b*b));
    h2(j)=exp(-norm(z2-c(:,j))^2/(b*b));
end

p=[2.9 0.76 0.87 3.04 0.87];
D=[p(1)+p(2)+2*p(3)*cos(q2) p(2)+p(3)*cos(q2);
    p(2)+p(3)*cos(q2) p(2)];
H=[h1;h2];
Kv=200*eye(2);
miu=100;
epN=0.50;
bd=0.2;

M=2;
if M==1
    sat=sign(r);
elseif M==2 %Saturated function 
   fai0=0.01;
   if norm(r)<=fai0
      sat=r/fai0;
   else
      sat=sign(r);
   end
end
v=-(epN+bd)*sat;

Kw=Kv*r;
Dr=D*r;
%tol=(r.*fai)/2*(H.*H)+Kv*r-v+miu*D*r;    
tol(1)=faip/2*r(1)*norm(h1)^2+Kw(1)-v(1)+miu*Dr(1);
tol(2)=faip/2*r(2)*norm(h2)^2+Kw(2)-v(2)+miu*Dr(2);
sys(1)=tol(1);
sys(2)=tol(2);