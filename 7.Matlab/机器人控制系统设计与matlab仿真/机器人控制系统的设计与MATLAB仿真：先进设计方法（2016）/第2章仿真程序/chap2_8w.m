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
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0=[0];
str = [];
ts = [0 0];
function sys=mdlDerivatives(t,x,u)
x1=u(2);
x2=u(3);
v=u(4);

g=9.8;m=1;L=1.0;
I=4/3*m*L^2;

fx=-1/I*(2*x2+m*g*L*cos(x1));

X=x(1);
N=(X^2)*cos(X);

c=10;c1=10;c2=10;c3=10;
uM=20;

yd=u(1);
dyd=cos(t);
ddyd=-sin(t);
dddyd=-cos(t);

z1=x1-yd;
dz1=x2-dyd;

alfa1=-c1*z1;
dalfa1=-c1*dz1;
z2=x2-alfa1-dyd;

alfa2=-fx-c2*z2-z1+dalfa1+ddyd;

dalfa2_x1=-c1*c2-1;
dalfa2_x2=-10-c2-c1;
dalfa2_yd=c1*c2+1;
dalfa2_dyd=c2+c1;
dalfa2_ddyd=1;

gv=uM*tanh(v/uM);
dg_v=4/(exp(v/uM)+exp(-v/uM))^2;

z3=gv-alfa2;

df_x1=0;df_x2=-10;

dalfa2=dalfa2_x1*x2+dalfa2_x2*(fx+gv)+dalfa2_yd*dyd+dalfa2_dyd*ddyd+dalfa2_ddyd*dddyd;
wb=-c3*z3+dalfa2+c*v*dg_v-z2;

gamax=1.0;
dX=gamax*z3*wb;
sys(1)=dX;
function sys=mdlOutputs(t,x,u)
x1=u(2);
x2=u(3);
v=u(4);

g=9.8;m=1;L=1.0;
I=4/3*m*L^2;

fx=-1/I*(2*x2+m*g*L*cos(x1));

X=x(1);
N=(X^2)*cos(X);
c=10;c1=10;c2=10;c3=10;
uM=20;

yd=u(1);
dyd=cos(t);
ddyd=-sin(t);
dddyd=-cos(t);

z1=x1-yd;
dz1=x2-dyd;

alfa1=-c1*z1;
dalfa1=-c1*dz1;
z2=x2-alfa1-dyd;

alfa2=-fx-c2*z2-z1+dalfa1+ddyd;

dalfa2_x1=-c1*c2-1;
dalfa2_x2=-10-c2-c1;
dalfa2_yd=c1*c2+1;
dalfa2_dyd=c2+c1;
dalfa2_ddyd=1;

gv=uM*tanh(v/uM);
dg_v=4/(exp(v/uM)+exp(-v/uM))^2;

z3=gv-alfa2;

df_x1=0;df_x2=-10;

dalfa2=dalfa2_x1*x2+dalfa2_x2*(fx+gv)+dalfa2_yd*dyd+dalfa2_dyd*ddyd+dalfa2_ddyd*dddyd;
wb=-c3*z3+dalfa2+c*v*dg_v-z2;

w=N*wb;

sys(1)=w;
sys(2)=X;