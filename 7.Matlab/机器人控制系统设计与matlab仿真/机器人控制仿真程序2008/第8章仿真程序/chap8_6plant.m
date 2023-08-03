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
sizes.NumContStates  = 7;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 7;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = [0,0,0,0.2362,-0.8128,0.3430,-0.4073];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
d1=0.005*sin(t);
d2=0.005*sin(t);
d3=0.005*sin(t);
I1=720;I2=800;I3=550;

M=u;
%State equation
sys(1)=1/I1*((I2-I3)*x(3)*x(2)+M(1)+d1);     %Angle speed 1
sys(2)=1/I2*((I3-I1)*x(3)*x(1)+M(2)+d2);     %Angle speed 2
sys(3)=1/I3*((I1-I2)*x(1)*x(2)+M(3)+d3);     %Angle speed 3
sys(4)=1/2*(-x(1)*x(5)-x(2)*x(6)-x(3)*x(7)); %Angle 1
sys(5)=1/2*(x(1)*x(4)+x(3)*x(6)-x(2)*x(7));  %Angle 2
sys(6)=1/2*(x(2)*x(4)-x(3)*x(5)+x(1)*x(7));  %Angle 3
sys(7)=1/2*(x(3)*x(4)+x(2)*x(5)-x(1)*x(6));  %Angle 4

function sys=mdlOutputs(t,x,u)
for i=1:1:7
    sys(i)=x(i);
end