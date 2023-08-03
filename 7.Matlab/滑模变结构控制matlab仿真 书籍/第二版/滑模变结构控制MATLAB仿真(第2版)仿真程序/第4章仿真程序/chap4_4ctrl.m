function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys=simsizes(sizes);
x0=[0 0];
str=[];
ts=[-1 0];
function sys=mdlDerivatives(t,x,u)
c1=10;c2=10;
deltau=u(4);
lamda1=x(1);
lamda2=x(2);

b=133;
sys(1)=-c1*lamda1+lamda2;
sys(2)=-c2*lamda2+b*deltau;
function sys=mdlOutputs(t,x,u)
c1=10;c2=10;
xd=sin(t);
dxd=cos(t);
ddxd=-sin(t);

x1=u(2);
x2=u(3);
deltau=u(4);
f=-25*x2;
b=133;
D=10;

lamda1=x(1);
lamda2=x(2);
dlamda1=lamda2-c1*lamda1;
dlamda2=-c2*lamda2+b*deltau;

e=x1-xd-lamda1;
de=x2-dxd-dlamda1;

c=1.5;
s=c*e+de;
xite=D+0.5;

fai=0.02;
if abs(s)<=fai
   sat=s/fai;
else
   sat=sign(s);
end
vt=-1/b*(c*x2+c2*lamda2+(c1-c)*dlamda1+f-c*dxd-ddxd)-1/b*xite*sat;

sys(1)=vt;