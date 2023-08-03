function [sys,x0,str,ts]=s_function(t,x,u,flag)
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
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.5,0,0.5,0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
tol=[u(1);u(2)];
g=9.8;
M11=0.1+0.01*cos(x(3));
M12=0.01*sin(x(3));
M21=M12;
M22=0.1;
M=[M11 M12;M21 M22];

C11=-0.01*sin(x(3))*x(4)/2;
C12=0.01*cos(x(3))*x(4)/2;
C21=C12;
C22=0;
C=[C11 C12;C21 C22];

G1=0.01*g*cos(x(1)+x(3));
G2=0.01*g*cos(x(1)+x(3));
G=[G1;G2];

dt=[2*sin(2*pi*t);1.5*cos(2*pi*t)];
   
S=inv(M)*(tol-C*[x(2);x(4)]-G)+dt;

sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);