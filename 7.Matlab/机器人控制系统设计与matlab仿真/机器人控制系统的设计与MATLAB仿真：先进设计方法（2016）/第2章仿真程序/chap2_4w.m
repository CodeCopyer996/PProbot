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
x0=[];
str = [];
ts = [0 0];
function sys=mdlOutputs(t,x,u)
x1=u(2);
x2=u(3);
v=u(4);

fx=-10*x2;
c1=5;c2=5;c3=5;
uM=5;l=0.5;

yd=u(1);
dyd=0.1*cos(t);
ddyd=-0.1*sin(t);
dddyd=-0.1*cos(t);

z1=x1-yd;
dz1=x2-dyd;

alfa1=-c1*z1;
dalfa1=-c1*dz1;
z2=x2-alfa1-dyd;

alfa2=-fx-(c2+l)*z2+ddyd-z1+dalfa1;

dalfa2_x1=-c1*(c2+l)-1;
dalfa2_x2=-10-(c2+l)-c1;
dalfa2_yd=c1*(c2+l)+1;
dalfa2_dyd=(c2+l)+c1;
dalfa2_ddyd=1;

gv=uM*tanh(v/uM);
dg_v=4/(exp(v/uM)+exp(-v/uM))^2;

z3=gv-alfa2;

df_x1=0;df_x2=-10;

beta=dalfa2_x1*x2+dalfa2_x2*(fx+gv)+dalfa2_yd*dyd+dalfa2_dyd*ddyd+dalfa2_ddyd*dddyd;
w=-c3*z3+beta-z2-l*(dalfa2_x2)^2*z3;

dv=1/dg_v*w;
sys(1)=dv;