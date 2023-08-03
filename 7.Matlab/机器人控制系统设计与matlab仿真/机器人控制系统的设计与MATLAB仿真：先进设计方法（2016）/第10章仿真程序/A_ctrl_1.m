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
sizes.NumInputs      = 18;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
chap10_3int;
dphid=0;ddphid=0;
thetad=u(1);dthetad=u(2);ddthetad=u(3);
psid=u(4);dpsid=u(5);ddpsid=u(6);

theta=u(13);dtheta=u(14);
psi=u(15);dpsi=u(16);
phi=u(17);dphi=u(18);

thetae=theta-thetad;dthetae=dtheta-dthetad;
psie=psi-psid;dpsie=dpsi-dpsid;
phie=phi-phid;dphie=dphi-dphid;

kp4=15;kd4=15;
kp5=15;kd5=15;
kp6=135;kd6=35;

u12=-kp4*thetae-kd4*dthetae+ddthetad+l*K4/I1*dthetad;
u13=-kp5*psie-kd5*dpsie+ddpsid+l*K5/I2*dpsid;
u14=-kp6*phie-kd6*dphie+ddphid+l*K6/I3*dphid;

sys(1)=u12;
sys(2)=u13;
sys(3)=u14;