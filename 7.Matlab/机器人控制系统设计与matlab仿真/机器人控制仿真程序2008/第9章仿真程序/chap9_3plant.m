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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
ut=u(1);
J=0.2;

if x(2)==0
    F_static=0;
elseif x(2)>0
    Fc=0.15;Fs=0.6;alfa=0.02;Vs=0.05;
    F_static=[Fc+(Fs-Fc)*exp(-(x(2)/Vs)^2)]*sign(x(2))+alfa*x(2); % Static friction model
elseif x(2)<0
    Fc=0.2;Fs=0.7;alfa=0.03;Vs=0.05;
    F_static=[Fc+(Fs-Fc)*exp(-(x(2)/Vs)^2)]*sign(x(2))+alfa*x(2); % Static friction model
end
F=F_static;
sys(2)=1/J*(ut-F);
sys(1)=x(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);