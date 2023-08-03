function [sys,x0,str,ts] = slave(t,x,u,flag)        

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
sizes.NumContStates  = 2;        
sizes.NumDiscStates  = 0;        
sizes.NumOutputs     = 3;        
sizes.NumInputs      = 1;        
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1; % At least one sample time is needed
sys = simsizes(sizes);
x0  = [0;0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u) 
Ms=0.768;
bs=417.5;
bw = 30;
cw = 1500;
bv = 0;%20*sin(0.001*t);
cv = 0;%500*sin(0.001*t);
fs = (bw+bv)*x(2)+(cw+cv)*x(1);
ds=2*sin(t);

sys(1)=x(2);
sys(2)=(-bs*x(2)-fs+u+ds)/Ms;
function sys=mdlOutputs(t,x,u)
bw = 30;
cw = 1500;
bv = 0;%20*sin(0.1*t);
cv = 0;%500*sin(0.1*t);
fs = (bw+bv)*x(2)+(cw+cv)*x(1);
sys(1)=x(1);
sys(2)=x(2);
sys(3) = fs;