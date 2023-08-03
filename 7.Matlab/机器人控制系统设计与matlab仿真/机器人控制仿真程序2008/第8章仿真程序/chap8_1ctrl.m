function [sys,x0,str,ts] = control_strategy(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
alfa=4;beta=4;

ym=u(1);
r=sign(sin(0.25*t));
dym=u(2);
y=u(3);
dy=u(4);

A=[0 1;
   -alfa -beta];
Q=[1 0;0 1];

P=lyap(A',Q);   % help lyap
p2=P(1,2);
p3=P(2,2);

e=ym-y;
de=dym-dy;
pe=p2*e+p3*de;

m=0.1183;M=0.1447;
n=1.1623;N=1.4207;

kp=m-alfa;
kd=n-beta;
gp=M-alfa;
gd=N-beta;
gama_s=0.05;gama_f=0.3;
eta=0.50;

if abs(dy)>eta
    nmn=1;
else
    nmn=0;
end
Kp=1/2*((1-sign(pe*y))*kp+(1+sign(pe*y))*gp);
Kd=1/2*((1-sign(pe*dy))*kd+(1+sign(pe*dy))*gd);
Ks=nmn*sign(pe)*gama_s+(1-nmn)*sign(pe)*gama_f;
ut=alfa*r+Kp*y+Kd*dy+Ks;
sys(1)=ut;