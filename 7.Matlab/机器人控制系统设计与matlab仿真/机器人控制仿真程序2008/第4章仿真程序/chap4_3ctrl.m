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
sizes.NumOutputs     = 3;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
x1=u(1);
x2=u(2);

xd=0;dxd=0;ddxd=0;

k1=2;k2=1;
k=[k2;k1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u1_1=1/(1+exp(-30*x1));
u1_2=1/(1+exp(30*x1));

u2_1=1/(1+exp(-30*x2));
u2_2=1/(1+exp(30*x2));

Fnum=-5*u1_1*u2_1+5*u1_2*u2_2;
Fden=u1_1*u2_1+u1_2*u2_1+u1_1*u2_2+u1_2*u2_2;
ufuzz=Fnum/Fden;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[0 -k2;
   1 -k1];
Q=[10 0;0 10];
P=lyap(A,Q);

b=[0;1];
x=[x1;x2];

gL=1.1;
fU=15.78+0.0366*x2^2;
us=-sign(x'*P*b)*(1/gL*(fU+abs(k'*x))+abs(ufuzz));

a=pi/18;
Mx=pi/9;

S=1;
if S==1
    if norm(x)>=Mx
        I=1;
    else
        I=0;
    end
elseif S==2
    if norm(x)<a
       I=0;
    elseif norm(x)<Mx&norm(x)>=a
       I=(norm(x)-a)/(Mx-a);
    else
       I=1;
    end
end
ut=ufuzz+I*us;
sys(1)=ufuzz;
sys(2)=us;
sys(3)=ut;