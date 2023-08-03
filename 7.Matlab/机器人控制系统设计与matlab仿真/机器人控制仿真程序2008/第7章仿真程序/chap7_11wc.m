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
sizes.NumOutputs     = 3;
sizes.NumInputs      = 12;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
for i=1:1:3
    if u(i)>0.1
        sat(i)=1;
    elseif u(i)<-0.1
        sat(i)=-1;
    else sat(i)=u(i)/0.1;  
    end
end
Sat_sw=[sat(1) sat(2) sat(3)]';

gama=u(4);
Fai=u(5);
R=[1 tan(Fai)*sin(gama) tan(Fai)*cos(gama);
   0 cos(gama)           -sin(gama);
   0 sin(gama)/cos(Fai) cos(gama)/cos(Fai)];
the=[u(7) u(8) u(9)]';
dthc=[u(10) u(11) u(12)]';

K1=0.3;
rou1=5;
wc=inv(R)*(dthc+K1*the+rou1*Sat_sw);
sys(1)=wc(1);
sys(2)=wc(2);
sys(3)=wc(3);