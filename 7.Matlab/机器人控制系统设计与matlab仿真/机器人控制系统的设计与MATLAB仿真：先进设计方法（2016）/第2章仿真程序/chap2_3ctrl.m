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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
xd=u(1);    
dxd=cos(t);
ddxd=-sin(t);

x1=u(2);
x2=u(3);
dp=u(5);

e=x1-xd;
de=x2-dxd;

alfa=10;beta=10;
k=10;l=10;

J=1.0;
ut=-alfa*tanh(k*e+l*de)-beta*tanh(l*de)-dp+ddxd;
sys(1)=ut;   %Umax=J*(alfa_max+beta_max+D+d0_error+ddxd_max)=10+10+5+0+1=26