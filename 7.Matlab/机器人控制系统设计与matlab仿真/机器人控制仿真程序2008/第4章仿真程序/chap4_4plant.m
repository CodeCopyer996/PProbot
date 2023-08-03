function [sys,x0,str,ts]=MIMO_Tong_plant(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0 0.5 0 0.5];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)   %Ref to PID411
m1=1;me=2;
l1=1;
lc1=0.5;lce=0.6;
I1=0.12;
Ie=0.25;
Qe=30*pi/180;%0.6;

a1=I1+m1*lc1^2+Ie+me*lce^2+me*l1^2;
a2=Ie+me*lce^2;
a3=me*l1*lce*cos(Qe);
a4=me*l1*lce*sin(Qe);

M11=a1+2*a3*cos(x(3))+2*a4*sin(x(3));
M22=a2;
M21=a2+a3*cos(x(3))+a4*sin(x(3));
M12=M21;
M=[M11 M12;M21 M22];

h=a3*sin(x(3))-a4*cos(x(3));

q1=x(1);dq1=x(2);
q2=x(3);dq2=x(4);
q=[q1;q2];
dq=[dq1;dq2];

tol=[u(1);u(2)];
hq=[-h*x(4) -h*(x(2)+x(4));h*x(2) 0];

S=inv(M)*(tol-hq*dq);
sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);