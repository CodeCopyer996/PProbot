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
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0=[0,0 0 0];
str=[];
ts=[0 0];
function sys=mdlDerivatives(t,x,u)
Gama1=2;Gama2=2;
k=0.20;

w=[u(1) u(2)];
r=[u(3) u(4)];
ut=[u(5) u(6)];;

if w(1)<0
   Xp1=0;Xn1=1;
else
   Xp1=1;Xn1=0;
end
if w(2)<0
   Xp2=0;Xn2=1;
else
   Xp2=1;Xn2=0;
end
X1=[Xp1;-Xn1];
X2=[Xp2;-Xn2];

d1p=x(1);d1n=x(2);
d2p=x(3);d2n=x(4);

D1=[d1p d1n]';
D2=[d2p d2n]';

dD1=Gama1*X1*r(1)-k*Gama1*D1*abs(r(1));
dD1p=dD1(1);
dD1n=dD1(2);

dD2=Gama2*X2*r(2)-k*Gama2*D2*abs(r(2));
dD2p=dD2(1);
dD2n=dD2(2);

sys(1)=dD1p;
sys(2)=dD1n;
sys(3)=dD2p;
sys(4)=dD2n;
function sys=mdlOutputs(t,x,u)
w=[u(1) u(2)];
r=[u(3) u(4)];
ut=[u(5) u(6)];;

if w(1)<0
   Xp1=0;Xn1=1;
else
   Xp1=1;Xn1=0;
end
if w(2)<0
   Xp2=0;Xn2=1;
else
   Xp2=1;Xn2=0;
end
X1=[Xp1;-Xn1];
X2=[Xp2;-Xn2];

d1p=x(1);d1n=x(2);
d2p=x(3);d2n=x(4);

D1=[d1p d1n];
D2=[d2p d2n];

sys(1)=D1*X1;
sys(2)=D2*X2;