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
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [pi/2-0.01,0,0,0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
theta1=0.0104;theta2=0.0052;theta3=0.0047;theta4=0.0805;theta5=0.0344;
g=9.8;

q1=x(1);dq1=x(2);q2=x(3);dq2=x(4);

M11=theta1+theta2+2*theta3*cos(q2);
M12=theta2+theta3*cos(q2);
M21=M12;
M22=theta2;

h1=-2*theta3*sin(q2)*dq2*dq1-theta3*sin(q2)*dq2^2+theta4*g*cos(q1)+theta5*g*cos(q1+q2);
h2=theta3*sin(q2)*dq1^2+theta5*g*cos(q1+q2);

M=M11*M22-M12*M21;

f1=(-M22*h1+M12*h2)/M;
b1=M22/M;
f2=(M21*h1-M11*h2)/M;
b2=-M21/M;
d1=0;d2=0;

tol1=u(1);
sys(1)=x(2);
sys(2)=f1+b1*tol1+d1;    %ddq1
sys(3)=x(4);
sys(4)=f2+b2*tol1+d2;    %ddq2
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);