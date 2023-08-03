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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 15;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  =[];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
chap10_2int;
vdx=u(1);vdy=u(2);vdz=u(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=u(4);dx1=u(5);
y1=u(6);dy1=u(7);
z1=u(8);dz1=u(9);
theta=u(10);dtheta=u(11);
psi=u(12);dpsi=u(13);
phi=u(14);dphi=u(15);
p=[x1 y1 z1]';
v=[dx1 dy1 dz1]';

xd=-5*sin(t/(2*pi));
yd=2.5*sin(t/(2*pi));
zd=-0.5*t;

ddxd=2.5/pi*1/(2*pi)*sin(t/(2*pi));
ddyd=-1.25/pi*1/(2*pi)*sin(t/(2*pi));
ddzd=0;

Pd=[xd yd zd]';
vd=[vdx vdy vdz]';
ve=v-vd;
ddPd=[ddxd ddyd ddzd]';

xite=3.0;
u1=-xite*ve+ddPd+[K1/m*dx1 K2/m*dy1 K3/m*dz1]'+[0 0 g]';
u1x=u1(1);u1y=u1(2);u1z=u1(3);

X=(cos(phi)*cos(phi)*u1x+cos(phi)*sin(phi)*u1y)/u1z;
%To Gurantee X is [-1,1]
if X>1 
    sin_thetad=1;
    thetad=pi/2;
elseif X<-1
    sin_thetad=-1;
    thetad=-pi/2;
else
    sin_thetad=X;
    thetad=asin(X);
end
psid=atan((sin(phi)*cos(phi)*u1x-cos(phi)*cos(phi)*u1y)/u1z);

u1=u1z/(cos(phi)*cos(psid));
sys(1)=u1; 
sys(2)=thetad;
sys(3)=psid;