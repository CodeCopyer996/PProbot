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
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1; % At least one sample time is needed
sys = simsizes(sizes);
x0 = [0.5;0;0];

str = [];
ts = [0 0];
function sys=mdlDerivatives(t,x,u)   %Lugre model
K=5000;
T=0.5+1.5*abs(sin(2*pi*t));

Jmin=100;
Jmax=200;
J=(Jmin+Jmax)/2+(Jmax-Jmin)/2*sin(2*pi*t);

Fc=0.5;
bc=0.3;
d=Fc*sign(x(2))+bc*x(2);

sys(1)=x(2);
sys(2)=x(3);
sys(3)=-1/T*x(3)+K/(J*T)*(u-d);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);