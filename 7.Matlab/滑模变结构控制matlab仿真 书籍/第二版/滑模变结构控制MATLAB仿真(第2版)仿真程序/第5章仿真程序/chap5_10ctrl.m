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
c1=27;c2=27;c3=9;

g=9.8;M=1.0;m=0.1;L=0.5;
I=1/12*m*L^2;  
l=1/2*L;
t1=m*(M+m)*g*l/[(M+m)*I+M*m*l^2];
t2=-m^2*g*l^2/[(m+M)*I+M*m*l^2];
t3=-m*l/[(M+m)*I+M*m*l^2];
t4=(I+m*l^2)/[(m+M)*I+M*m*l^2];

th1=u(1); %th
th2=u(2); %dth
z1=u(3);  %x
z2=u(4);  %dx

x1=z1-t4/t3*th1;
x2=z2-t4/t3*th2;
x3=th1;
x4=th2;

T=t2-t1*t4/t3;

b=1;
f1=T*x3;
f2=0;
f1_x1=0;
f1_x2=0;
f1_x3=T;
beta1=0;
beta2=0;
beta3=T+0.1;

ueq=-inv(f1_x3*b)*(c1*x2+c2*f1+c3*f1_x1*x2+c3*f1_x2*f1+c3*f1_x3*x4);

e1=x1;
e2=x2;
e3=f1;
e4=T*x4;
s=c1*e1+c2*e2+c3*e3+e4;

rou=1.0;
M=rou;
nmn=1.0;
usw=-inv(f1_x3*b)*(M*s+nmn*s);   
ut=ueq+usw;

v=(ut-t1*th1)/t3;

sys(1)=v;