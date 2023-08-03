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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
dthd=u(1);
thd=u(2);
th=u(5);

the=th-thd;
s1=the;
k1=10;xite1=0.50;

delta=0.10;
kk=1/delta;
if abs(s1)>delta
  	sats=sign(s1);
else
	sats=kk*s1;
end
%w=dthd-k1*s1-xite1*sign(s1);
w=dthd-k1*s1-xite1*sats;

sys(1)=w;