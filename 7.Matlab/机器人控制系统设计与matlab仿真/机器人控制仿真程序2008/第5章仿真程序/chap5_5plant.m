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
x0  = [3;0;0;1];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
%a=1;
a=1000*rands(1);

d1=a*0.3*sin(3*pi*t);
d2=a*0.1*(1-exp(-t));

dq1=x(1);      %Angle1 speed:dq1
dq2=x(2);      %Angle2 speed:dq2
q1=x(3);       %Angle1:q1
q2=x(4);       %Angle2:q2

tol1=u(1);
tol2=u(2);
%%%%%%%%%%%%%%%%%%%%%%%%% From aslpd_con_s.m
m1=10;m2=5;
l1=1;l2=0.5;
r1=0.5;r2=0.25;
i1=0.83+m1*r1^2+m2*l1^2;
i2=0.3+m2*r2^2;
g=9.8;

D=[i1+i2+2*m2*r2*l1*cos(q2) i2+m2*r2*l1*cos(q2);
   i2+m2*r2*l1*cos(q2) i2];
C=[-m2*r2*l1*dq2*sin(q2),-m2*r2*l1*(dq1+dq2)*sin(q2);
    m2*r2*l1*dq1*sin(q2),0];
G=[(m1*r1+m2*l1)*g*cos(q1)+m2*r2*g*cos(q1+q2);m2*r2*g*cos(q1+q2)];
%%%%%%%%%%%%%%%%%%%%%%%%%%

D2=inv(D);
Ta=[d1;d2];
A=-D2*C;
Z=-D2*G;

sys(1)=A(1,1)*x(1)+A(1,2)*x(2)+Z(1)+D2(1,1)*(-Ta(1)+tol1)+D2(1,2)*(-Ta(2)+tol2);
sys(2)=A(2,1)*x(1)+A(2,2)*x(2)+Z(2)+D2(2,1)*(-Ta(1)+tol1)+D2(2,2)*(-Ta(2)+tol2);
sys(3)=x(1);
sys(4)=x(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);   %Angle1 speed:dq1
sys(2)=x(2);   %Angle2 speed:dq2
sys(3)=x(3);   %Angle1:q1
sys(4)=x(4);   %Angle2:q2