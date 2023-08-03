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
sizes.NumContStates  = 3;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;0;0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)   %Time-varying model
w=[u(1) u(2) u(3)]';
gama=x(1);
Fai=x(2);

R=[1 tan(Fai)*sin(gama) tan(Fai)*cos(gama);
   0 cos(gama)           -sin(gama);
   0 sin(gama)/cos(Fai) cos(gama)/cos(Fai)];

dth=R*w;

sys(1)=dth(1);
sys(2)=dth(2);
sys(3)=dth(3);
function sys=mdlOutputs(t,x,u)

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);