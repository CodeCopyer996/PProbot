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
global uM vM
uM=3;vM=3;
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = [0 0];
str = [];
ts = [0 0];
function sys=mdlDerivatives(t,x,u)
global uM vM
Ut=u(1);

v=x(1);
w=x(2);
gv=uM*tanh(v/uM);
fw=vM*tanh(w/vM);

dg_dv=4/(exp(v/uM)+exp(-v/uM))^2;
df_dw=4/(exp(w/vM)+exp(-w/vM))^2;

dv=inv(dg_dv)*fw;
dw=inv(df_dw)*Ut;
sys(1)=dv;
sys(2)=dw;
function sys=mdlOutputs(t,x,u)
global uM vM
v=x(1);
w=x(2);

ut=uM*tanh(v/uM);
du=vM*tanh(v/vM);
sys(1)=ut;
sys(2)=du;
sys(3)=v;
sys(4)=w;