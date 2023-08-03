function [sys,x0,str,ts]= NDO(t,x,u,flag)
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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
g=9.8;
T=[u(1);u(2)];
q=[u(3);u(5)];
dq=[u(4);u(6)];
J=[0.1+2*0.01*cos(q(2)) 0.01*sin(q(2))
   0.01*sin(q(2)) 0.01];
G1=0.01*g*cos(q(1)+q(2));
G2=0.01*g*cos(q(1)+q(2));
G=[G1;G2];

c=1.5;
L=c*[1 0;1 1]*inv(J);
p=c*[dq(1);dq(1)+dq(2)];

dz=-L*x+L*(G-T-p);
sys(1)=dz(1);
sys(2)=dz(2);
function sys=mdlOutputs(t,x,u)
c=1.5;
dq=[u(4);u(6)];
p=c*[dq(1);dq(1)+dq(2)];
sys(1)=x(1)+p(1);
sys(2)=x(2)+p(2);