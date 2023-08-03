function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
v=u(1);
if v==0
    F_static=0;
elseif v>0
    Fc=0.1503;Fs=0.6343;alfa=0.0191;Vs=0.0499;
    F_static=[Fc+(Fs-Fc)*exp(-(v/Vs)^2)]*sign(v)+alfa*v; % Static friction model
elseif v<0
    Fc=0.2001;Fs=0.73;alfa=0.0295;Vs=0.0506;
    F_static=[Fc+(Fs-Fc)*exp(-(v/Vs)^2)]*sign(v)+alfa*v; % Static friction model
end
Fp=F_static;
sys(1)=Fp;