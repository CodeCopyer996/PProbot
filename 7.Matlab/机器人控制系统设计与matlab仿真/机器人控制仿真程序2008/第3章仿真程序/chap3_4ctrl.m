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
global c b kp kv
sizes = simsizes;
sizes.NumContStates  = 5;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = 0.1*ones(1,5);
str = [];
ts  = [];

c=0.60*ones(2,5);
b=3.0*ones(5,1);
kp=20;kv=10;
function sys=mdlDerivatives(t,x,u)
global c b kp kv

A=[0   1;
  -kp -kv];
B=[0;1];
Q=[50 0;
   0 50];
P=lyap(A',Q);
eig(P);

qd=u(1);
dqd=cos(t);

q=u(2);dq=u(3);
e=q-qd;
de=dq-dqd;

xi=[e;de];
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-c(:,j))^2/(2*b(j)*b(j)));
end

gama=150;
Mth=1.0;

th=[x(1) x(2) x(3) x(4) x(5)]';

M1=2;
if M1==1       % Adaptive Law
    S=gama*h*xi'*P*B;
elseif M1==2   % Adaptive Law with UUB
    k1=0.001;
    S=gama*h*xi'*P*B+k1*gama*norm(x)*th;
end
S=S';
for i=1:1:5
    sys(i)=S(i);
end

function sys=mdlOutputs(t,x,u)
global c b kp kv
q=u(2);
dq=u(3);
ddq=u(4);

g=9.8;m=1;l=0.25;
D0=4/3*m*l^2;
C0=2.0;
G0=m*g*l*cos(q);

d_D0=0.2*D0;
d_C0=0.2*C0;
d_G0=0.2*G0;
d=1.3*sin(0.5*pi*t);

qd=u(1);
dqd=cos(t);
ddqd=-sin(t);

e=q-qd;
de=dq-dqd;

M=3;
if M==1              %Control for Precise Model
    tol1=D0*(ddqd-kv*de-kp*e)+C0*dq+G0;
    tol2=0;
    tol=tol1;
elseif M==2          %Control with Precise Nonlinear Compensation
    f=1/D0*(d_D0*ddq+d_C0*dq+d_G0+d);
    tol1=D0*(ddqd-kv*de-kp*e)+C0*dq+G0;
    tol2=-D0*f;
    tol=tol1+tol2;
elseif M==3          %Control with Neural Compensation
    tol1=D0*(ddqd-kv*de-kp*e)+C0*dq+G0;
    th=[x(1) x(2) x(3) x(4) x(5)]';
    xi=[e;de];
    h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-c(:,j))^2/(2*b(j)*b(j)));
end
    f=1/D0*(d_D0*ddq+d_C0*dq+d_G0+d);
    fn=th'*h;
    tol2=-D0*fn;
    tol=tol1+1*tol2;
end

sys(1)=tol1;
sys(2)=tol2;
sys(3)=tol;
if M==3
    sys(4)=f;
    sys(5)=fn;
else
    sys(4)=0;
    sys(5)=0;
end