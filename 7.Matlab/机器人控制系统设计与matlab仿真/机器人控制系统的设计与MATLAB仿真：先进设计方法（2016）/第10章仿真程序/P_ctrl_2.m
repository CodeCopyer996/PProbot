function [sys,x0,str,ts] = func(t,x,u,flag) 
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
sizes.NumInputs      = 39;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  =[];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
chap10_3int;
vdx=u(1);vdy=u(2);vdz=u(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=u(4);dx1=u(5);
y1=u(6);dy1=u(7);
z1=u(8);dz1=u(9);
theta1=u(10);dtheta1=u(11);
psi1=u(12);dpsi1=u(13);
phi1=u(14);dphi1=u(15);
p1=[x1 y1 z1]';
vj1=[dx1 dy1 dz1]';
%//////////////////////////
x2=u(16);dx2=u(17);
y2=u(18);dy2=u(19);
z2=u(20);dz2=u(21);
theta2=u(22);dtheta1=u(23);
psi2=u(24);dpsi2=u(25);
phi2=u(26);dphi2=u(27);
p2=[x2 y2 z2]';
vj2=[dx2 dy2 dz2]';
%///////////////////////////
x3=u(28);dx3=u(29);
y3=u(30);dy3=u(31);
z3=u(32);dz3=u(33);
theta3=u(34);dtheta3=u(35);
psi3=u(36);dpsi3=u(37);
phi3=u(38);dphi3=u(39);
p3=[x3 y3 z3]';
vj3=[dx3 dy3 dz3]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vjd=[vdx vdy vdz]';
vje2=vj2-vjd;

vdx=-2.5/pi*cos(t/(2*pi));
vdy=1.25/pi*cos(t/(2*pi));
vdz=-0.5;

ddxd=2.5/pi*1/(2*pi)*sin(t/(2*pi));
ddyd=-1.25/pi*1/(2*pi)*sin(t/(2*pi));
ddzd=0;

ddPjd=[ddxd ddyd ddzd]';

delta1=[1 1 0]'; delta2=[-1 1 0]'; delta3=[-1 -1 0]'; 

delta_11=0;delta_12=delta1-delta2;delta_13=delta1-delta3;
delta_21=delta2-delta1;delta_22=0;delta_23=delta2-delta3;
delta_31=delta3-delta1;delta_32=delta3-delta2;delta_33=0;
P_11=0;P_12=p1-p2;P_13=p1-p3;
P_21=p2-p1;P_22=0;P_23=p2-p3;
P_31=p3-p1;P_32=p3-p2;P_33=0;

sum2=(P_21-delta_21)+(P_22-delta_22)+(P_23-delta_23);
xite=5.0;
U21=-xite*vje2+ddPjd+[K1/m*dx2 K2/m*dy2 K3/m*dz2]'+[0 0 g]'-2*sum2;
u21x=U21(1);u21y=U21(2);u21z=U21(3);

X2=(cos(phi2)*cos(phi2)*u21x+cos(phi2)*sin(phi2)*u21y)/u21z;
%To Gurantee X is [-1,1]
if X2>1 
    sin_thetad=1;
    thetad2=pi/2;
elseif X2<-1
    sin_thetad=-1;
    thetad2=-pi/2;
else
    sin_thetad=X2;
    thetad2=asin(X2);
end
psid2=atan((sin(phi2)*cos(phi2)*u21x-cos(phi2)*cos(phi2)*u21y)/u21z);

u21=u21z/(cos(phi2)*cos(psid2));
sys(1)=u21; 
sys(2)=thetad2;
sys(3)=psid2;