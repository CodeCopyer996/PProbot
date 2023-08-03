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
x1d=u(1);dx1d=u(2);ddx1d=u(3);dddx1d=u(4);ddddx1d=u(5);
x(1)=u(6);x(2)=u(7);x(3)=u(8);x(4)=u(9);dx2=u(10);

z1=x(1)-x1d;
dz1=x(2)-dx1d;
a1=-c1*z1;
z2=x(2)-(a1+dx1d);

dz2=-(1/I)*(Mgl*sin(x(1))+K*(x(1)-x(3)))+c1*x(2)-c1*dx1d-ddx1d;

a2=-(I/K)*[-(1/I)*(Mgl*sin(x(1))+K*x(1))+c1*x(2)-c1*dx1d-ddx1d+z1+c2*z2];
z3=x(3)-a2;

S1=(-1/I)*(Mgl*cos(x(1))*x(2)+K*x(2))+c1*c2*x(2)+(c1+c2)*(-1/I)*(Mgl*sin(x(1))+K*(x(1)-x(3)))-c1*c2*dx1d-(c1+c2)*ddx1d-dddx1d+x(2)-dx1d;
dz3=x(4)+(I/K)*S1;

a3=-(I/K)*S1-(K/I)*z2-c3*z3;
z4=x(4)-a3;

dS=-(1/I)*(-Mgl*sin(x(1))*x(2)^2+Mgl*cos(x(1))*dx2+K*dx2)+c1*c2*dx2+(c1+c2)*(-1/I)*(Mgl*cos(x(1))*x(2)+K*(x(2)-x(4)))-c1*c2*ddx1d-(c1+c2)*dddx1d-ddddx1d+dx2-ddx1d;
D=100000;
xite=D+0.10;

fai=0.20;
if abs(z4)<=fai
    sat=z4/fai;
else
    sat=sign(z4);
end   
%ut=-xite*sign(z4)-J*(-(K/J)*(x(3)-x(1))+(I/K)*dS+K/I*dz2+c3*dz3+z3+c4*z4);
ut=-xite*sat-J*(-(K/J)*(x(3)-x(1))+(I/K)*dS+K/I*dz2+c3*dz3+z3+c4*z4);
sys(1)=ut;