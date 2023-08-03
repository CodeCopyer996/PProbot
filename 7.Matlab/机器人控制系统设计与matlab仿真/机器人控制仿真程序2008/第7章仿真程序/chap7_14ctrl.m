function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
    case 0,
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 3,
        sys=mdlOutputs(t,x,u);
    case {1,2,4,9},
        sys=[];
    otherwise
        error(['unhandled flag=',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes=simsizes;
sizes.NumContStates=0;
sizes.NumDiscStates=0;
sizes.NumOutputs=2;
sizes.NumInputs=7;
sizes.DirFeedthrough=1;
sizes.NumSampleTimes=0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
x1d=u(1);x4d=u(2);
x1=u(3);x2=u(4);x3=u(5);x4=u(6);x5=u(7);

a0=-17.66;a1=-0.1;a2=-0.1;a3=5.31e-4;
a4=1.534e-2;a5=2.82e-7;a6=1.632e-5;
a7=-13.92;a8=-0.7;a9=-0.0028;a10=-0.0028;
a11=434.88;a12=-800;a13=-0.1;a14=-65;

f1=x2;
f2=a0+a1*x2+a2*x2^2+(a3+a4*x4-sqrt(a5+a6*x4))*x3^2;
f3=a7+a8*x3+(a9*sin(x4)+a10)*x3^2;
f4=x5;
f5=a11+a12*x4+a13*x3^2*sin(x4)+a14*x5;

r=a3+a4*x4-sqrt(a5+a6*x4);
k=x3^2*(a4*x5-1/2*a6*x5*(a5+a6*x4)^(-0.5));

c11=120;c12=20;c21=25;

z11=x1;
z12=x2;
z13=f2;
s1=c11*(x1d-z11)-c12*z12-z13;

z21=x4;
dz21=x5;
s2=c21*(x4d-z21)-dz21;

D1=5;D2=1.0;
F=(a1+2*a2*x2)*f2+2*x3*f3*r+k;
v1=-F-c11*z12-c12*z13+D1*sign(s1);

z22=x5;
v2=-f5+D2*sign(s2)-c21*z22;

u1=v1/(2*x3*r+0.01);
u2=v2;

sys(1)=u1;
sys(2)=u2;