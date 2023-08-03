function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
xd=u(1);    
dxd=cos(t);
ddxd=-sin(t);

x1=u(2);
x2=u(3);

c=15.0;
e=x1-xd;
de=x2-dxd;
s=c*e+de;
k=5;
alfa=k*s+c*de-ddxd;

gama=10;
sgn_th=1.0;
dp=alfa*gama*s*sgn_th;

sys(1)=dp; 
function sys=mdlOutputs(t,x,u)
xd=u(1);    
dxd=cos(t);
ddxd=-sin(t);

x1=u(2);
x2=u(3);

c=15.0;
e=x1-xd;
de=x2-dxd;
s=c*e+de;
p_estimation=x(1); 

k=5;
alfa=k*s+c*de-ddxd;
uc=-p_estimation*alfa;

rou1=1.0;
if t>=5
   rou1=0.20;
end
rou2=1.0;
if t>=10
   rou2=0;
end

u1=rou1*uc;
u2=rou2*uc;
sys(1)=u1; 
sys(2)=u2;