function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {1, 2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys=simsizes(sizes);
x0=[ ];
str=[];
ts=[0 0];
function sys=mdlOutputs(t,x,u)
g=9.8;M=1.0;m=0.1;L=0.5;
I=1/12*m*L^2;l=1/2*L;

T4=-m*l/(I+m*l^2);
T2=-m^2*g*l^2/[(m+M)*I+M*m*l^2];
T3=(I+m*l^2)/[(m+M)*I+M*m*l^2];
T1=m*(M+m)*g*l/[(M+m)*I+M*m*l^2]-T4*T2;

th=u(1);dth=u(2);
x=u(3);dx=u(4);

q1=th;q2=x;
p1=dth;p2=dx;

z1=q1+m*l/(I+m*l^2)*q2;
z2=p1+m*l/(I+m*l^2)*p2;
kesi1=q2;
kesi2=p2;

miu1=kesi2;
miu2=[z1 z2 kesi1]';
%%%%%%%%%%%%%%%%%%%%%%;
k=5;
c3=-3*k;
c2=-(3*k^2+T1)/(T1*T4);
c1=-(k^3-T1*c3)/(T1*T4);
C=[c1 c2 c3];
%%%%%%%%%%%%%%%%%%%%%%%
sigma=miu1-C*miu2;

dmiu2=[z2;T1*z1+T1*T4*kesi1;kesi2];

h=1.5;
fai=0.01;
if abs(sigma)<=fai
   sat=sigma/fai;
else
   sat=sign(sigma);
end
ut=1/T3*(-T2*z1-T2*T4*kesi1+C*dmiu2-h*sat);

sys(1)=ut;