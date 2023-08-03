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
sizes.NumContStates  = 20;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 8;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = 0*(1:20);
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
x1=u(1);
ut=u(2);
A0=[-12 1 0 0;
    -54 0 1 0;
    -108 0 0 1;
    -81 0 0 0];
k=[12;54;108;81];
f1=[0;x1;0;0];
f2=[0;sin(x1);0;0];
f3=[0;0;0;sin(x1)];
e4=[0;0;0;1];

w=[x(1);x(2);x(3);x(4)];
psi1=[x(5);x(6);x(7);x(8)];
psi2=[x(9);x(10);x(11);x(12)];
psi3=[x(13);x(14);x(15);x(16)];
v=[x(17);x(18);x(19);x(20)];

dw=A0*w+k*x1;
dpsi1=A0*psi1+f1;
dpsi2=A0*psi2+f2;
dpsi3=A0*psi3+f3;
dv=A0*v+e4*ut;

sys(1)=dw(1);
sys(2)=dw(2);
sys(3)=dw(3);
sys(4)=dw(4);

sys(5)=dpsi1(1);
sys(6)=dpsi1(2);
sys(7)=dpsi1(3);
sys(8)=dpsi1(4);

sys(9)=dpsi2(1);
sys(10)=dpsi2(2);
sys(11)=dpsi2(3);
sys(12)=dpsi2(4);

sys(13)=dpsi3(1);
sys(14)=dpsi3(2);
sys(15)=dpsi3(3);
sys(16)=dpsi3(4);

sys(17)=dv(1);
sys(18)=dv(2);
sys(19)=dv(3);
sys(20)=dv(4);
function sys=mdlOutputs(t,x,u)
sys(1)=x(2);   %w2
sys(2)=x(6);   %psi12
sys(3)=x(10);  %psi22
sys(4)=x(14);  %psi32
sys(5)=x(17);  %v1
sys(6)=x(18);  %v2
sys(7)=x(19);  %v3
sys(8)=x(20);  %v4
