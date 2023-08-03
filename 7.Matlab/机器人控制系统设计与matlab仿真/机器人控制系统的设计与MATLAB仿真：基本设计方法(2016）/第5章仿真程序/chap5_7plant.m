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
sizes.NumOutputs     = 4;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;2*pi;1;0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
g=9.81;
m1=1;m2=1;
l1=0.5;l2=0.5;
lc1=0.25;lc2=0.25;
I1=0.1;I2=0.1;

q1=x(1);
dq1=x(2);
q2=x(3);
dq2=x(4);

m11=m1*lc1^2+m2*(l1^2+lc2^2+2*l1*lc2*cos(q2))+I1+I2;
m12=m2*(lc2^2+l1*lc2*cos(q2))+I2;
m21=m12;
m22=m2*lc2^2+I2;
M=[m11 m12;m21 m22];

h=-m2*l1*lc2*sin(q2);
c11=h*dq2;
c12=h*dq1+h*dq2;
c21=-h*dq1;
c22=0;
C=[c11 c12;c21 c22];

G1=(m1*lc1+m2*l1)*g*cos(q1)+m2*lc2*g*cos(q1+q2);
G2=m2*lc2*g*cos(q1+q2);
G=[G1;G2];

d1=rand(1)*sin(t);
d2=rand(1)*sin(t);
d=[d1;d2];

tol=[u(1) u(2)]';

S=inv(M)*(tol+d-C*[dq1;dq2]-G);

sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);   %Angle1:q1
sys(2)=x(2);   %Angle1 speed:dq1
sys(3)=x(3);   %Angle2:q2
sys(4)=x(4);   %Angle2 speed:dq2