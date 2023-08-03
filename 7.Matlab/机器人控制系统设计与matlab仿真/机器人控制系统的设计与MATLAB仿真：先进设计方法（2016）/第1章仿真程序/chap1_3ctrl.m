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
sizes.NumOutputs     = 3;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
yd=u(1);dyd=cos(t);ddyd=-sin(t);

x1=u(2);x2=u(3);

f=-25*x2;b=133;

z1=x1-yd;
dz1=x2-dyd;
z2=dz1;

k=10;
kb1=0.6;  %kb1 must bigger than z1(0)
kb2=0.15;  %kb2 must bigger than z2(0)

M=2;
if M==1
temp=-f+ddyd+(kb2^2-z2^2)*(-z1/(kb1^2-z1^2)-k*dz1);
ut=temp/b;
elseif M==2
temp1=b/(kb2^2-z2^2)+b;
temp2=-z1/(kb1^2-z1^2)-1/(kb2^2-z2^2)*(f-ddyd)-z1-f+ddyd-k*dz1;
ut=1/temp1*temp2;
end

sys(1)=ut;
sys(2)=z1;
sys(3)=z2;