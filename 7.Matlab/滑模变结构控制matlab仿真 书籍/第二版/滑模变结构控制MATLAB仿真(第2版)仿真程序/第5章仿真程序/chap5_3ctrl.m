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
x1=u(1);
x2=u(2);
x3=u(3);
x4=u(4);
c1=27;c2=27;c3=9;

l=10;g=9.8;
f1=g*sin(x1)/l+x3;

b=1;
f2=0;
f1_x1=g*cos(x1)/l;
f1_x2=0;
f1_x3=1;
beta1=g/l+0.1;
beta2=0;
beta3=1.0+0.1;
D=-g/l*sin(x1)*x2^2+g/l*cos(x1)*f1;

ueq=-inv(f1_x3*b)*(c1*x2+c2*f1+c3*f1_x1*x2+c3*f1_x2*f1+c3*f1_x3*x4+D);

e1=x1;
e2=x2;
e3=f1;
e4=f1_x1*x2+f1_x2*f1+f1_x3*x4;
s=c1*e1+c2*e2+c3*e3+e4;

d_up=10;

rou=1.0;
M=beta3*d_up+rou;
nmn=1.0;

S=2;
if S==1
    sat=sign(s);
elseif S==2         %Saturated function 
   fai=0.05;
   if abs(s)<=fai
      sat=s/fai;
   else
      sat=sign(s);
   end
end
usw=-inv(f1_x3*b)*(M*sat+nmn*s);   
ut=ueq+usw;
sys(1)=ut;