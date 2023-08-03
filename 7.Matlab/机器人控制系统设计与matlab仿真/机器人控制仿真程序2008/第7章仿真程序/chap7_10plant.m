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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u) 
dq=[x(1) x(2)]';
tol=[u(1) u(2)]';
q1=u(3);
q2=u(4);
dq1=u(5);
dq2=u(6);

v=13.33;m1=8.98;m2=8.75;g=9.8;
M=[v+m1+2*m2*cos(q2) m1+m2*cos(q2);
   m1+m2*cos(q2) m1];
C=[-m2*dq2*sin(q2) -m2*(dq1+dq2)*sin(q2);
    m2*dq1*sin(q2)  0];
G=[15*g*cos(q1)+8.75*g*cos(q1+q2);
   8.75*g*cos(q1+q2)];

d1=2;d2=3;d3=6;

e1=q1-cos(t);
de1=dq1+sin(t);
e2=q2-cos(t);
de2=dq2+sin(t);

d=[d1+d2*norm([e1,e2])+d3*norm([de1,de2])]+1000*sin(pi*t);
 
ddq=inv(M)*(-C*dq+tol-G-d);

sys(1)=ddq(1);
sys(2)=ddq(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);