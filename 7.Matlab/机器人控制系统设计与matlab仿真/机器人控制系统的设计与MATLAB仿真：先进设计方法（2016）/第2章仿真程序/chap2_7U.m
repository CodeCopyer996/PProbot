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
dyd=cos(t);ddyd=-sin(t);dddyd=-cos(t);

x1=u(2);x2=u(3);
ut=u(4);du=u(5);
v=u(6);w=u(7);

c1=3;c2=2;c3=1.5;c4=1.5;

uM=3;vM=3;
gv=uM*tanh(v/uM);
fw=vM*tanh(w/vM);

z1=x1-yd;
dz1=x2-dyd;
alfa1=-c1*z1;
dalfa1=-c1*(x2-dyd);
z2=x2-alfa1-dyd;
%alfa2=-z1-c2*z2+dalfa1+ddyd;
alfa2=-x1+yd-c2*(x2+c1*x1-c1*yd-dyd)-c1*(x2-dyd)+ddyd;

z3=gv-alfa2;
dalfa2_x1=-1-c2*c1;
dalfa2_x2=-c2-c1;
dalfa2_yd=1+c2*c1;
dalfa2_dyd=c2+c1;
dalfa2_ddyd=1;

dalfa2=dalfa2_x1*x2+dalfa2_x2*gv+dalfa2_yd*dyd+dalfa2_dyd*ddyd+dalfa2_ddyd*dddyd;
theta1=dalfa2;

%alfa3=-z2-c3*z3+theta1;
alfa3=-x2-c1*(x1-yd)+dyd-c3*(gv-alfa2)+theta1;

z4=fw-alfa3;
 
dtheta1_x1=0;
dtheta1_x2=dalfa2_x1;
dtheta1_yd=0;
dtheta1_dyd=dalfa2_yd;
dtheta1_ddyd=dalfa2_dyd;
dtheta1_dddyd=dalfa2_ddyd;
dtheta1_gv=dalfa2_x2;

dalfa3_x1=-c1+c3*dalfa2_x1+dtheta1_x1;
dalfa3_x2=-1+c3*dalfa2_x2+dtheta1_x2;
dalfa3_gv=-c3+dtheta1_gv;
dalfa3_yd=c1+c3*dalfa2_yd+dtheta1_yd;
dalfa3_dyd=1+c3*dalfa2_dyd+dtheta1_dyd;
dalfa3_ddyd=c3*dalfa2_ddyd+dtheta1_ddyd;
dalfa3_dddyd=dtheta1_dddyd;

theta2=dalfa3_x1*x2+dalfa3_x2*gv+dalfa3_gv*fw+dalfa3_yd*dyd+dalfa3_dyd*ddyd+dalfa3_ddyd*dddyd;

Ut=theta2-z3-c4*z4;
sys(1)=Ut; 