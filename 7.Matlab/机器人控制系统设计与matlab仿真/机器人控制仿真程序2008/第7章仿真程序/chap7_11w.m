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
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;0;0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)   %Time-varying model
J0=[86 0 0;
    0 85 0;
    0 0 113];
dJ=[-5 0 0;
    0 -5 0;
    0 0 -5];
d=[sin(t) cos(t) sin(2*t)]';
    
w=[x(1) x(2) x(3)]';
OM=[0    -x(3) -x(2);
    x(3) 0     -x(1);
   -x(2) x(1)     0];
 
M=[u(1) u(2) u(3)]';
 
dw=inv(J0+dJ)*(-OM*(J0+dJ)*w+M+d);

sys(1)=dw(1);
sys(2)=dw(2);
sys(3)=dw(3);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);