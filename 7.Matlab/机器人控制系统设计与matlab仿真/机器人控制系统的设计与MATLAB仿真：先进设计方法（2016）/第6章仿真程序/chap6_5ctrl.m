function [sys,x0,str,ts] = MIMO_Tong_s(t,x,u,flag)
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
global c bj k1 k2 k3 k4 node
node=5;
sizes = simsizes;
sizes.NumContStates  = 3*node+1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [zeros(3*node,1);500];   %m(0)>ml
str = [];
ts  = [];
c=1.5*[-2 -1 0 1 2;
       -2 -1 0 1 2;
       -2 -1 0 1 2;
       -2 -1 0 1 2];
bj=10;

k1=0.35;k2=0.35;k3=0.35;k4=0.35;
function sys=mdlDerivatives(t,x,u)
global c bj k1 k2 k3 k4 node
yd=u(1);
dyd=cos(t);
ddyd=-sin(t);
dddyd=-cos(t);
ddddyd=sin(t);

zf=[u(2) u(3) u(4) u(5)]';
for j=1:1:node
    h(j)=exp(-norm(zf-c(:,j))^2/(2*bj*bj));
end

th_gp=[x(1:node)]';          %gp
th_dp=[x(node+1:node*2)]';   %dp
th_fp=[x(node*2+1:node*3)]'; %fp
gp=th_gp*h';
dp=th_dp*h';
fp=th_fp*h';
mp=x(3*node+1);

x1=u(2);x2=u(3);x3=u(4);x4=u(5);

e1=x1-yd;
x2d=dyd-k1*e1;
e2=x2-x2d;
dx2d=ddyd-k1*(x2-dyd);

x3d=-gp+dx2d-k2*e2-e1;
D3=dddyd-k1*(x3-ddyd)-k2*(x3-dx2d)+dyd-x2;
e3=x3-x3d;
x4d=D3-dp-k3*e3-e2;
e4=x4-x4d;

D4=ddddyd-k1*(x4-dddyd)-k2*(x4-dddyd+k1*(x3-ddyd))+ddyd-x3-k3*(x4-D3)-(x3-dx2d);

ut=(1/mp)*(-fp+D4-k4*e4-e3);
Kexi=[e1 e2 e3 e4]';    

n=0.01;
Gama2=250;Gama3=250;Gama4=250;
xite=150;
ml=1;
    if (e4*ut>0)
        dm=(1/xite)*e4*ut;
    end
    if (e4*ut<=0)
        if (mp>ml)
        dm=(1/xite)*e4*ut;
        else
        dm=1.0;
        end
    end

for i=1:1:node
    sys(i)=Gama2*h(i)*e2-n*Gama2*norm(Kexi)*th_gp(i);
    sys(i+node)=Gama3*h(i)*e3-n*Gama3*norm(Kexi)*th_dp(i);
    sys(i+node*2)=Gama4*h(i)*e4-n*Gama4*norm(Kexi)*th_fp(i);
end
sys(3*node+1)=dm;
function sys=mdlOutputs(t,x,u)
global c bj k1 k2 k3 k4 node
yd=u(1);
dyd=cos(t);
ddyd=-sin(t); 
dddyd=-cos(t);
ddddyd=sin(t);

x1=u(2);x2=u(3);x3=u(4);x4=u(5);
zf=[x1 x2 x3 x4]';
for j=1:1:node
    h(j)=exp(-norm(zf-c(:,j))^2/(2*bj*bj));
end

th_gp=[x(1:node)]';          %gp
th_dp=[x(node+1:node*2)]';   %dp
th_fp=[x(node*2+1:node*3)]'; %fp
gp=th_gp*h';
dp=th_dp*h';
fp=th_fp*h';
mp=x(node*3+1);

e1=x1-yd;
x2d=dyd-k1*e1;
e2=x2-x2d;
dx2d=ddyd-k1*(x2-dyd);
x3d=-gp+dx2d-k2*e2-e1;
D3=dddyd-(k1)*(x3-ddyd)-(k2)*(x3-dx2d)+dyd-x2;
e3=x3-x3d;
x4d=D3-dp-k3*e3-e2;
e4=x4-x4d;

D4=ddddyd-(k1)*(x4-dddyd)-(k2)*(x4-dddyd+(k1)*(x3-ddyd))-(k3)*(x4-D3)-(x3-dx2d)+ddyd-x3;
ut=(1/mp)*(-fp+D4-k4*e4-e3);
sys(1)=ut;
sys(2)=gp;