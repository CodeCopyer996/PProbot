function [sys,x0,str,ts] = sliddingmode_1(t,x,u,flag)        

switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys = mdlOutputs(t,x,u);
case {1,2,4,9}
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;        
sizes.NumDiscStates  = 0;        
sizes.NumOutputs     = 2;        
sizes.NumInputs      = 5;        
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,x,u)
Mm=10;
bm=400;
Ms=0.8;
bs=400;
bw = 30;
dbw =2*sin(0.001*t);
cw = 1500;
dcw =100*sin(0.001*t);

ds_max=2.0;
xite = 1/Ms*ds_max;

c = 15;
xs = u(1);
dxs = u(2);
um = u(3);
xm = u(4);
dxm = u(5);

e = xm - xs;
de = dxm - dxs;
ddxm = -bm/Mm*dxm + um/Mm;

fs = (bw+dbw)*dxs+(cw+dcw)*xs;
s = de + c*e;
tols=(ddxm+c*de+xite*sign(s))*Ms+fs+bs*dxs;

sys(1) = tols;
sys(2) = s ;