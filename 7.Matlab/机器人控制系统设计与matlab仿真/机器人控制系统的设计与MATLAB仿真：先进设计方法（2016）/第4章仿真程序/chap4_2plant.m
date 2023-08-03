%double links adptive fuzzy control by backstepping
function [sys,x0,str,ts]= D1plant (t,x,u,flag)
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
x0=[1.0 1.0 0 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
m1=0.765;m2=0.765;
l1=0.25;l2=0.25;
r1=0.15;r2=0.15;
J1=4/3*m1*r1^2+m2*l1^2;
J2=4/3*m2*r2^2;

q1=x(1);q2=x(2);
dq1=x(3);dq2=x(4);

M11=J1+J2+2*m2*r2*l1*cos(q2);
M12=J2+m2*r2*l1*cos(q2);
M21=M12;
M22=J2;
M=[M11 M12;
   M21 M22];
C11=-2*m2*r2*l1*dq2*sin(q2);
C12=-m2*r2*l1*dq2*sin(q2);
C21=m2*r2*l1*dq1*sin(q2);
C22=0;
C=[C11 C12;
   C21 C22];
d=[0.25*sin(t) 0.25*sin(t)]';

tol=u;
sys(1)=x(3);
sys(2)=x(4);
S=-inv(M)*C*[dq1;dq2]+inv(M)*(u-d);
sys(3)=S(1);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);