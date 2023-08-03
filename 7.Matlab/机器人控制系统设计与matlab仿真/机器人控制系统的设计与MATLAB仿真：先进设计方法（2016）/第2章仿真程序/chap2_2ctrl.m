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
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [6];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)

Jp=x(1);
x1d=u(1);
dx1d=cos(t);
ddx1d=-sin(t);
x1=u(2);
x2=u(3);

e1=x1-x1d;
e2=x2-dx1d;

Jmin=5;Jmax=15;

alfa=10;beta=10;k=10;l=1.0;
gama=10;

alaw=gama*(alfa*k*e2*tanh(k*e1+l*e2)-k*e2*ddx1d+l*alfa*tanh(k*e1+l*e2)*ddx1d+l*beta*tanh(l*e2)*ddx1d);

N=2;
if N==1
    sys(1)=alaw;
elseif N==2
    if Jp>=Jmax&alaw>0
        sys(1)=0;
    elseif Jp<=Jmin&alaw<0
        sys(1)=0;
    else
    sys(1)=alaw;
    end
end

function sys=mdlOutputs(t,x,u)
x1d=u(1);    
dx1d=cos(t);
ddx1d=-sin(t);

x1=u(2);
x2=u(3);

e1=x1-x1d;
e2=x2-dx1d;

alfa=10;beta=10;
k=10;l=1.0;

v=-alfa*tanh(k*e1+l*e2)-beta*tanh(l*e2); 
Jp=x(1);
ut=Jp*(v+ddx1d);

Jmin=5;Jmax=15;
ddx1d_max=1.0;
u_max=Jmax*(alfa+beta+ddx1d_max);

sys(1)=ut;
sys(2)=Jp;