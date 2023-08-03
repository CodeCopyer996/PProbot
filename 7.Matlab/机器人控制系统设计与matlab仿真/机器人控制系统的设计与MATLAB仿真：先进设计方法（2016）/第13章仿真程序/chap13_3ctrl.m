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
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0 0 0 0];
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

gama1=10;gama2=10;
sgn_b1=1;sgn_b2=-1;

dk11=gama1*s*alfa*sgn_b1;
dk21=gama1*s*sgn_b1;
dk12=gama2*s*alfa*sgn_b2;
dk22=gama2*s*sgn_b2;

sys(1)=dk11; 
sys(2)=dk21; 
sys(3)=dk12; 
sys(4)=dk22; 
function sys=mdlOutputs(t,x,u)
k11p=x(1);
k21p=x(2);
k12p=x(3);
k22p=x(4);

xd=u(1);dxd=cos(t);ddxd=-sin(t);
x1=u(2);x2=u(3);

c=15;
e=x1-xd;
de=x2-dxd;
s=c*e+de;

k=5;
alfa=k*s+c*de-ddxd;
uc1=-k11p*alfa-k21p;
uc2=-k12p*alfa-k22p;

rou1=1.0;rou2=1.0;
u1_bar=0;u2_bar=0;
if t>=8
rou1=0.20;
rou2=0;u2_bar=0.2;
end

u1=rou1*uc1+u1_bar;
u2=rou2*uc2+u2_bar;
sys(1)=u1; 
sys(2)=u2;