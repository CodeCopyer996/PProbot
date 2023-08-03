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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,x,u)
R1=u(1);
dr1=-pi*sin(pi*t);
ddr1=-pi^2*cos(pi*t);

R2=u(2);
dr2=pi*cos(pi*t);
ddr2=-pi^2*sin(pi*t);

x(1)=u(3);
x(2)=u(4);
x(3)=u(5);
x(4)=u(6);

e1=R1-x(1);
e2=R2-x(3);
de1=dr1-x(2);
de2=dr2-x(4);

v=13.33;q1=8.98;q2=8.75;g=9.8;
M=[v+q1+2*q2*cos(x(3)) q1+q2*cos(x(3));
   q1+q2*cos(x(3)) q1];

C=[-q2*x(4)*sin(x(3)) -q2*(x(2)+x(4))*sin(x(3));
    q2*x(2)*sin(x(3))  0];
G=[15*g*cos(x(1))+8.75*g*cos(x(1)+x(3));
   8.75*g*cos(x(1)+x(3))];
H=C*[x(2);x(4)]+G;
fU=3;fL=-3;
fm=(fU-fL)/2;
fp=(fU+fL)/2;

ddr=[ddr1;ddr2];

c1=5;c2=5;
s1=c1*e1+de1;
s2=c2*e2+de2;
s=[s1;s2];

eq=0.5;k=5;
tol=M*([c1*de1;c2*de2]+ddr+eq*sign(s)+k*s)+H-(fp-fm*sign(s));

sys(1)=tol(1);
sys(2)=tol(2);