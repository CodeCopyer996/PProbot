function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
    case 0,
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 1,
        sys=mdlDerivatives(t,x,u);
    case 3,
        sys=mdlOutputs(t,x,u);
    case {2,4,9},
        sys=[];
    otherwise
        error(['unhandled flag=',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes=simsizes;
sizes.NumContStates=5;
sizes.NumDiscStates=0;
sizes.NumOutputs=5;
sizes.NumInputs=2;
sizes.DirFeedthrough=1;
sizes.NumSampleTimes=1;
sys=simsizes(sizes);
x0=[0,0,200,0,0];
str=[];
ts=[0 0];
function sys=mdlDerivatives(t,x,u)
a0=-17.66;a1=-0.1;a2=-0.1;a3=5.31e-4;
a4=1.534e-2;a5=2.82e-7;a6=1.632e-5;
a7=-13.92;a8=-0.7;a9=-0.0028;a10=-0.0028;
a11=434.88;a12=-800;a13=-0.1;a14=-65;
f1=x(2);
f2=a0+a1*x(2)+a2*x(2)^2+(a3+a4*x(4)-sqrt(a5+a6*x(4)))*x(3)^2;
f3=a7+a8*x(3)+(a9*sin(x(4))+a10)*x(3)^2;
f4=x(5);
f5=a11+a12*x(4)+a13*x(3)^2*sin(x(4))+a14*x(5);
g1=[0,0,1,0,0]';
g2=[0,0,0,0,1]';
u1=u(1);
u2=u(2);
f=[f1,f2,f3,f4,f5]';
sys=f+g1*u1+g2*u2;
function sys=mdlOutputs(t,x,u)
sys=x;