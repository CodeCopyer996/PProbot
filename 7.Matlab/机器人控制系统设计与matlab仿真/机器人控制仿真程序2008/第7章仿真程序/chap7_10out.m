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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
sw=[u(1) u(2)]';
e=[u(3) u(4)]';
dr=[u(5) u(6)]';

for i=1:1:2
    if sw(i)>0.01
        sat(i)=1;
    elseif sw(i)<-0.01
        sat(i)=-1;
    else sat(i)=sw(i)/0.01;  
    end
end
Sat=[sat(1) sat(2)]';

k1=0.3;rou1=15;
wd=dr+k1*e+rou1*Sat;

sys(1)=wd(1);
sys(2)=wd(2);