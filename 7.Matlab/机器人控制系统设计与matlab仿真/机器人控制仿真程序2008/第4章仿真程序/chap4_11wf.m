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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0=[0,0];
str=[];
ts=[0 0];
function sys=mdlDerivatives(t,x,u)
Gama=10;k=0.20;

w=u(1);
r=u(2);
ut=u(3);
if w<0
   Xp=0;Xn=1;
else
   Xp=1;Xn=0;
end

X=[Xp;-Xn];
dD=Gama*X*r-k*Gama*[x(1);x(2)]*abs(r);

sys(1)=dD(1);
sys(2)=dD(2);
function sys=mdlOutputs(t,x,u)
w=u(1);
if w<0
   Xp=0;Xn=1;
else
   Xp=1;Xn=0;
end
   
X=[Xp;-Xn];

Dp=[x(1) x(2)];
sys(1)=Dp*X;