function [sys,x0,str,ts]=obser(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
x1d=u(1);
dx1d=cos(t);
ddx1d=-sin(t);

fxp=u(2);gxp=u(3);
x1p=u(4);x2p=u(5);
x1=u(6);

k1=30;
k2=5;
e1=x1p-x1d;
de1=x2p-dx1d;
x2dp=dx1d-k1*e1;
dx2dp=ddx1d-k1*de1;
e2=x2p-x2dp;

k4=5;
ye=x1-x1p;
D1=0.10;
v=-D1*sign(ye);

ut=1/(gxp+0.1)*(-fxp+dx2dp+v-k4*ye-k2*e2-e1);
sys(1)=ut;