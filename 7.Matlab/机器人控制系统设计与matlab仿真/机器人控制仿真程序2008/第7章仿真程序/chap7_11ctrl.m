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
sizes.NumOutputs     =3;
sizes.NumInputs      =12;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
J0=[86 0 0;
    0 85 0;
    0 0 113];
OM=[0 -u(6) -u(5);
    u(6) 0 -u(4);
    -u(5) u(4) 0];
K2=1;miu=10;rou2=1.5;
sn=[u(1) u(2) u(3)]';
w=[u(4) u(5) u(6)]';
we=[u(7) u(8) u(9)]';
dwc=[u(10) u(11) u(12)]';
M=J0*dwc+J0*K2*we+OM*J0*w+miu*sn+rou2*sign(sn);

sys(1)=M(1);
sys(2)=M(2);
sys(3)=M(3);