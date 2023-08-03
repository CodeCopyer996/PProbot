function [sys,x0,str,ts] = obser(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
global c b
sizes = simsizes;
sizes.NumContStates  = 15;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = 0.1*ones(1,15);
str=[];
ts=[];
c=0.60*ones(2,5);
b=3.0*ones(5,1);
function sys=mdlDerivatives(t,x,u)
global c b
y=u(1);
ut=u(2);
x1p=u(3);
x2p=u(4);
xp=[x1p x2p]';
yp=x1p;
ye=y-yp;

h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xp-c(:,j))^2/(2*b(j)*b(j)));
end
h1=x(11:1:15);

F1=50000*eye(5);
F2=5000*eye(5);

k1=0.001;k2=0.001;
W1=[x(1) x(2) x(3) x(4) x(5)];
W2=[x(6) x(7) x(8) x(9) x(10)];

dW1=F1*h1*ye-k1*F1*abs(ye)*W1';
dW2=F2*h1*ye-k2*F2*abs(ye)*W2';
for i=1:1:5
    sys(i)=dW1(i);
    sys(i+5)=dW2(i);
end
for i=11:1:15
    sys(i)=h(i-10)-3*x(i);
end

function sys=mdlOutputs(t,x,u)
global c b
W1=[x(1) x(2) x(3) x(4) x(5)];
W2=[x(6) x(7) x(8) x(9) x(10)];
h1=x(11:1:15);

fxp=W1*h1;
gxp=W2*h1;

sys(1)=fxp;
sys(2)=gxp;