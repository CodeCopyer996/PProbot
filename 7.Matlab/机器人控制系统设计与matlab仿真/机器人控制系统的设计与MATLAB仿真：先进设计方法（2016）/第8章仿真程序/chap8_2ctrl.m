function [sys,x0,str,ts] =an_controller(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumOutputs = 2;
sizes.NumInputs = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
a2=-0.09;b2=1.67;
c2=10;c3=10;

u1=u(1);
faid=u(2);
dfaid=cos(t);
ddfaid=-sin(t);
fai=u(3);
dfai=u(4);

z1=fai-faid;
dz1=dfai-dfaid;
a1=-c2*z1+dfaid;
z2=dfai-a1;
u2=(a2*dfai+b2*u1+c2*dz1-ddfaid+z1+c3*z2)/(2*b2);

ur=u1-u2;
ul=u2;
if ur>=10
    ur=10;
elseif ur<=-10
    ur=-10;
end
if ul>=10
    ul=10;
elseif ul<=-10
    ul=-10;
end
out(1)=ur;
out(2)=ul;
sys=out;