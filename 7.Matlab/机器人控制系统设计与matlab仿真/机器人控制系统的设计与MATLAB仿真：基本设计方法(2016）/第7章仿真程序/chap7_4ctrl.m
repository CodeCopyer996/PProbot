function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
th1d=0.1*sin(t);
dth1d=0.1*cos(t);
ddth1d=-0.1*sin(t);

th2d=0.1*sin(t);
dth2d=0.1*cos(t);
ddth2d=-0.1*sin(t);

thd=[th1d th2d]';
dthd=[dth1d dth2d]';
ddthd=[ddth1d ddth2d]';

th1=u(5);dth1=u(6);
th2=u(7);dth2=u(8);
dp=[u(9) u(10)]';

th=[th1 th2]';
dth=[dth1 dth2]';

e=th-thd;
de=dth-dthd;

Fai=10*eye(2);
s=de+Fai*e;

g=9.8;
j1=0.1;j2=0;j3=0.01;Xp=0.01;
J=[j1+2*Xp*cos(th2) j2+Xp*cos(th2)
   j2+Xp*cos(th2) j3];
C=0;
G1=0.01*g*cos(th1+th2);
G2=0.01*g*cos(th1+th2);
G=[G1;G2];

 Xite=0.10*eye(2);
%Saturated function 
 delta=0.20;
 kk=1/delta;
 for i=1:2
 if abs(s(i))>delta
   	sats(i)=sign(s(i));
 else
 	sats(i)=kk*s(i);
 end
 end
v=ddthd-Fai*de;
tol=J*v+C*dth+G-Xite*[sats(1) sats(2)]'-dp-C*s;

sys(1)=tol(1);
sys(2)=tol(2);