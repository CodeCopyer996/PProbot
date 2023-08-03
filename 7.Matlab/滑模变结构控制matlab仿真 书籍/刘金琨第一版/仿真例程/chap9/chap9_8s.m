%S-function for continuous state equation
function [sys,x0,str,ts]=s_function(t,x,u,flag)

switch flag,
%Initialization
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
%Outputs
  case 3,
    sys=mdlOutputs(t,x,u);
%Unhandled flags
  case {2, 4, 9 }
    sys = [];
%Unexpected flags
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

%mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[];
str=[];
ts=[];

function sys=mdlOutputs(t,x,u)
qr1=u(1);
dqr1=7/5*exp(-t)-7/5*exp(-4*t);
ddqr1=-7/5*exp(-t)+28/5*exp(-4*t);

qr2=u(2);
dqr2=-exp(-t)+exp(-4*t);
ddqr2=exp(-t)-4*exp(-4*t);

x=u(3:1:6);
e1=x(1)-qr1;
e2=x(3)-qr2;
e=[e1;e2];
de1=x(2)-dqr1;
de2=x(4)-dqr2;
de=[de1;de2];

q=[x(1);x(3)];
dq=[x(2);x(4)];

s1=e1+(abs(de1))^(5/3)*sign(de1);
s2=e2+(abs(de2))^(5/3)*sign(de2);
s=[s1;s2];

r1=1;r2=0.8;
J1=5;J2=5;
m1=0.5;m2=1.5;
g=9.8;

a11=(m1+m2)*r1^2+m2*r2^2+2*m2*r1*r2*cos(x(3))+J1;
a12=m2*r1^2+m2*r1*r2*cos(x(3));
a22=m2*r2^2+J2;
b12=m2*r1*r2*sin(x(3));

gama1=((m1+m2)*r1*cos(x(3))+m2*r2*cos(x(1)+x(3)));
gama2=m2*r2*cos(x(1)+x(3));

M0=[a11 a12;a12 a22];
C0=[-b12*x(2)*x(2)-2*b12*x(2)*x(4);b12*x(4)*x(4)];
g0=[gama1*g;gama2*g];

ddqr=[ddqr1;ddqr2];
tao0=C0+g0+M0*ddqr;

z11=(abs(de1))^(1/3)*sign(de1);
z12=(abs(de2))^(1/3)*sign(de2);

z21=(abs(de1))^(2/3);
z22=(abs(de2))^(2/3);

C1=[150 0;0 150];
u0=-0.6*M0*inv(C1)*[z11;z12];

u2=-(s'*C1*[z21 0;0 z22]*inv(M0))'/(norm(s'*C1*[z21 0;0 z22]*inv(M0))+0.001)^2;
b0=1;b1=2;b2=3;
u1=u2*[norm(s)*norm(C1*[z21 0;0 z22]*inv(M0))*(b0+b1*norm(q)+b2*norm(dq)*norm(dq))];

tao=tao0+u0+u1;
tao1=tao(1);
tao2=tao(2);

sys(1)=tao1;
sys(2)=tao2;
sys(3)=e1;
sys(4)=de1;
sys(5)=e2;
sys(6)=de2;