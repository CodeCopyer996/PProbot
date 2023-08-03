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
sizes.NumOutputs     = 4;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.10,0,0.10,0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
q1_d=sin(2*pi*t);
q2_d=sin(2*pi*t);
dq1_d=2*pi*cos(2*pi*t);
dq2_d=2*pi*cos(2*pi*t);
ddq1_d=-(2*pi)^2*sin(2*pi*t);
ddq2_d=-(2*pi)^2*sin(2*pi*t);

e(1)=x(1)-q1_d;
e(2)=x(3)-q2_d;
de(1)=x(2)-dq1_d;
de(2)=x(4)-dq2_d;

tol=[u(1);u(2)];
q1=x(1);
dq1=x(2);
q2=x(3);
dq2=x(4);

m1=0.5;m2=0.5;
r1=1;r2=0.8;
g=9.8;

M11=(m1+m2)*r1^2+m2*r2^2+2*m2*r1*r2*cos(q2);
M12=m2*r2^2+m2*r1*r2*cos(q2);
M22=m2*r2^2;
M=[M11 M12;M12 M22];

C12=m2*r1*r2*sin(q2);
C=[-C12*dq2 -C12*(dq1+dq2);
   C12*dq1 0];

g1=(m1+m2)*r1*cos(q2)+m2*r2*cos(q1+q2);
g2=m2*r2*cos(q1+q2);
G=[g1*g;g2*g];
S=inv(M)*(tol-C*[dq1;dq2]-G);

sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);