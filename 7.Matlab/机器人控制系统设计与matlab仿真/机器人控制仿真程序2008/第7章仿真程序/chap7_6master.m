function [sys,x0,str,ts] = master(t,x,u,flag)        

switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys = mdlDerivatives(t,x,u);
case 3,
    sys = mdlOutputs(t,x,u);
case {2,4,9}
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 2;        
sizes.NumDiscStates  = 0;        
sizes.NumOutputs     = 2;        
sizes.NumInputs      = 2;        
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.2;0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)
Mm=10.768;
bm=420.7;
fm=u(2);
dm=0*cos(t);

dx(1) = x(2);
dx(2)= (-bm/Mm)*x(2) + (u(1)+fm-dm)/Mm;
sys = dx;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);