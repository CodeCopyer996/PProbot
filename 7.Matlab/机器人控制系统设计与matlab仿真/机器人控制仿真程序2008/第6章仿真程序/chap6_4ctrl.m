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
sizes.NumOutputs     = 1;
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
I=1.0;J=1.0;Mgl=5.0;
c1=50;c2=50;c3=50;c4=50;
K=1200;
%K=120;

qt=u(1);dqt=u(2);ddqt=u(3);dddqt=u(4);ddddqt=u(5);

x(1)=u(6);x(2)=u(7);x(3)=u(8);x(4)=u(9);dx2=u(10);

z1=x(1)-qt;
dz1=x(2)-dqt;
a1=-c1*z1;
z2=x(2)-(a1+dqt);

dz2=-(1/I)*(Mgl*sin(x(1))+K*(x(1)-x(3)))+c1*x(2)-c1*dqt-ddqt;

a2=-(I/K)*[-(1/I)*(Mgl*sin(x(1))+K*x(1))+c1*x(2)-c1*dqt-ddqt+z1+c2*z2];
z3=x(3)-a2;

S1=(-1/I)*(Mgl*cos(x(1))*x(2)+K*x(2))+c1*c2*x(2)+(c1+c2)*(-1/I)*(Mgl*sin(x(1))+K*(x(1)-x(3)))-c1*c2*dqt-(c1+c2)*ddqt-dddqt+x(2)-dqt;
dz3=x(4)+(I/K)*S1;

a3=-(I/K)*S1-(K/I)*z2-c3*z3;
z4=x(4)-a3;

S2=-(1/I)*(-Mgl*sin(x(1))*x(2)^2+Mgl*cos(x(1))*dx2+K*dx2)+c1*c2*dx2+(c1+c2)*(-1/I)*(Mgl*cos(x(1))*x(2)+K*(x(2)-x(4)))-c1*c2*ddqt-(c1+c2)*dddqt-ddddqt+dx2-ddqt;
tol=-J*(-(K/J)*(x(3)-x(1))+(I/K)*S2+K/I*dz2+c3*dz3+z3+c4*z4);
sys(1)=tol;