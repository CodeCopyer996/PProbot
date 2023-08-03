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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
xd=u(1);    
dxd=cos(t);
ddxd=-sin(t);
x1=u(2);
x2=u(3);

m=0.02;g=9.8;l=0.05;
g0=m*g*l*cos(x1);

M0=0.1+0.06*sin(x1);
C0=0.03*cos(x1)+0.5*x2^2;
fx=inv(M0)*(-C0-g0);
gx=inv(M0);

e=x1-xd;
de=x2-dxd;

l=5;

M=2;
if M==1              %Fixed Step is 0.0001 in Simulink
    lamda0=0.5001;   %>abs(e(0))=0.50
    lamda_inf=0.0001;
elseif M==2          %Fixed Step is 0.001 in Simulink
    lamda0=0.51;     %>abs(e(0))=0.50
    lamda_inf=0.01;
end
    
lamda=(lamda0-lamda_inf)*exp(-l*t)+lamda_inf;
dlamda=-l*(lamda0-lamda_inf)*exp(-l*t);
ddlamda=l^2*(lamda0-lamda_inf)*exp(-l*t);

S=e/lamda;

epc=0.5*log((1+S)/(1-S));   %To guarantee log effective, must use the suitable solver method in simulink

depc=(de*lamda-e*dlamda)/((lamda+e)*lamda);

D=3.0;
c=50;
k=10;

E=c*epc+depc;

M1=(ddlamda*(lamda+e)-(dlamda+de)^2)/(2*(lamda+e)^2);
M2=-(ddlamda*(lamda-e)-(dlamda-de)^2)/(2*(lamda-e)^2);
M3=(lamda+e)/(2*(lamda+e)^2)+(lamda-e)/(2*(lamda-e)^2);

xite=abs(M3*gx)*D+0.10;

delta=0.020;
kk=1/delta;
if abs(E)>delta
   satE=sign(E);
else
   satE=kk*E;
end
u1=-k*E-xite*satE-M1-M2-M3*fx+M3*ddxd-c*depc;
ut=u1/(M3*gx);

sys(1)=lamda;
sys(2)=ut;