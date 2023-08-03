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
sizes.NumInputs      = 7;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0=[];
str = [];
ts = [0 0];
function sys=mdlOutputs(t,x,u)
yd=u(1);
x1=u(2);x2=u(3);
ut=u(4);du=u(5);
v=u(6);w=u(7);

c1=1.5;c2=1.5;c3=1.5;c4=1.5;

uM=3;vM=3;
gv=uM*tanh(v/uM);
fw=vM*tanh(w/vM);

z1=x1-yd;
dz1=x2;
alfa1=-c1*z1;
dalfa1=-c1*dz1;
z2=x2-alfa1;
%alfa2=-z1-c2*z2+dalfa1;
alfa2=-x1+yd-c2*x2-c2*c1*x1+c2*c1*yd-c1*x2;

z3=gv-alfa2;
dalfa2_x1=-1-c2*c1;
dalfa2_x2=-c2-c1;

dalfa2=dalfa2_x1*x2+dalfa2_x2*gv;
theta1=dalfa2;

%alfa3=-z2-c3*z3+theta1;
alfa3=-x2-c1*(x1-yd)-c3*(gv-alfa2)+(-1-c2*c1)*x2+(-c2-c1)*gv;

z4=fw-alfa3;
 
dalfa3_gv=-c3-c2-c1;
dalfa3_x1=-c1+c3*dalfa2_x1;
dalfa3_x2=-1-c2*c1+c3*dalfa2_x2;

theta2=dalfa3_x1*x2+dalfa3_x2*gv+dalfa3_gv*fw;

Ut=theta2-z3-c4*z4;
sys(1)=Ut; 