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
sizes.NumOutputs     = 5;
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0; 
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
M=2;
if M==1          %Curve Signal
   qt=1.25-7/5*exp(-t)+7/20*exp(-4*t);
   dqt=7/5*exp(-t)-7/5*exp(-4*t);
   ddqt=-7/5*exp(-t)+28/5*exp(-4*t);
   dddqt=7/5*exp(-t)-112/5*exp(-4*t);
   ddddqt=-7/5*exp(-t)+448/5*exp(-4*t);
elseif M==2      %Sine Signal 
   A=0.50;w=3;
   qt=A*sin(w*2*pi*t);
	dqt=w*2*pi*A*cos(w*2*pi*t);
   ddqt=-(w*2*pi)^2*A*sin(w*2*pi*t);
   dddqt=-(w*2*pi)^3*A*cos(w*2*pi*t);
   ddddqt=(w*2*pi)^4*A*sin(w*2*pi*t);
elseif M==3      %Step Signal
   A=1.0;
   qt=A;
	dqt=0;ddqt=0;dddqt=0;ddddqt=0;
elseif M==4      %Square Signal
   A=1.0;w=1;
   qt=A*sign(sin(w*2*pi*t));
   dqt=0;ddqt=0;dddqt=0;ddddqt=0;
end

sys(1)=qt;
sys(2)=dqt;
sys(3)=ddqt;
sys(4)=dddqt;
sys(5)=ddddqt;