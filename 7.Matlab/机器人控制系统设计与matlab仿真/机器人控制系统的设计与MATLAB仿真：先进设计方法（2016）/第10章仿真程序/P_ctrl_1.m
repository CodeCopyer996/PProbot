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
vje1=vj1-vjd;

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

sum1=(P_11-delta_11)+(P_12-delta_12)+(P_13-delta_13);
xite=5.0;
U11=-xite*vje1+ddPjd+[K1/m*dx1 K2/m*dy1 K3/m*dz1]'+[0 0 g]'-2*sum1;
u11x=U11(1);u11y=U11(2);u11z=U11(3);

X1=(cos(phi1)*cos(phi1)*u11x+cos(phi1)*sin(phi1)*u11y)/u11z;
%To Gurantee X is [-1,1]
if X1>1 
    sin_thetad=1;
    thetad1=pi/2;
elseif X1<-1
    sin_thetad=-1;
    thetad1=-pi/2;
else
    sin_thetad=X1;
    thetad1=asin(X1);
end
psid1=atan((sin(phi1)*cos(phi1)*u11x-cos(phi1)*cos(phi1)*u11y)/u11z);

u11=u11z/(cos(phi1)*cos(psid1));
sys(1)=u11; 
sys(2)=thetad1;
sys(3)=psid1;