function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
q1=u(1);dq1=u(2);
q2=u(3);dq2=u(4);

theta1=0.0104;theta2=0.0052;theta3=0.0047;theta4=0.0805;theta5=0.0344;
g=9.8;

M11=theta1+theta2+2*theta3*cos(q2);
M12=theta2+theta3*cos(q2);
M21=M12;
M22=theta2;
 
h1=-2*theta3*sin(q2)*dq2*dq1-theta3*sin(q2)*dq2^2+theta4*g*cos(q1)+theta5*g*cos(q1+q2);
h2=theta3*sin(q2)*dq1^2+theta5*g*cos(q1+q2);
M=M11*M22-M21*M12;

f1=(-M22*h1+M12*h2)/M;
b1=M22/M;
f2=(M21*h1-M11*h2)/M;
b2=-M21/M;

a1=9;a2=27;a3=27;
theta=theta2+theta3;
alfa1=1.0;
alfa2=(a2*theta2+theta5*g)/(theta5*g+a2*theta);

N=theta2-alfa2*theta;
lambda2=-(a1*theta5*g+a3*theta2)*N/(theta3*theta5*g);
lambda1=lambda2-a3*N/(theta5*g);

e1=q1-pi/2;de1=dq1;
e2=q2;de2=dq2;

s=alfa1*de1+lambda1*e1+alfa2*de2+lambda2*e2;

d1_max=1;d2_max=0;
xite=abs(alfa1)*d1_max+abs(alfa2)*d2_max;
k=10; 

%Saturated function
delta=0.05;
kk=1/delta;
if abs(s)>delta
    sats=sign(s);
else
	sats=kk*s;
end
sr=lambda1*e1+lambda2*e2;
dsr=lambda1*de1+lambda2*de2;

%tol1=-1/(alfa1*b1+alfa2*b2)*(alfa1*f1+alfa2*f2+dsr+xite*sign(s)+k*s);
tol1=-1/(alfa1*b1+alfa2*b2)*(alfa1*f1+alfa2*f2+dsr+xite*sats+k*s);
sys(1)=tol1;