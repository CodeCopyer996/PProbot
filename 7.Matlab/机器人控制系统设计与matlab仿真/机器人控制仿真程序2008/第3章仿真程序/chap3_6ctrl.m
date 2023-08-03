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
global node c_D c_C c_G b
node=5;
c_D=[-1 -0.5 0 0.5 1];
c_G=[-1 -0.5 0 0.5 1];
c_C=[-1 -0.5 0 0.5 1;
     -2 -1 0 1 2];
b=1.5;

sizes = simsizes;
sizes.NumContStates  = 3*node;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 7;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = 0.3*ones(1,3*node);
str = [];
ts  = [];

function sys=mdlDerivatives(t,x,u)
global node c_D c_C c_G b
qd=u(1);
dqd=u(2);
ddqd=u(3);

q=u(4);
dq=u(5);

for j=1:1:node
    h_D(j)=exp(-norm(q-c_D(:,j))^2/(b*b));
end
for j=1:1:node
    h_G(j)=exp(-norm(q-c_G(:,j))^2/(b*b));
end

z=[q;dq];
for j=1:1:node
    h_C(j)=exp(-norm(z-c_C(:,j))^2/(b*b));
end

W_D=x(1:node)';
T_D=5;

e=qd-q;
de=dqd-dq;
Hur=5;
r=de+Hur*e;

dqr=dqd+Hur*e;
ddqr=ddqd+Hur*de;

for i=1:1:node
    sys(i)=T_D*h_D(i)*ddqr*r;
end

W_G=[x(node+1:2*node)]';
T_G=10;
for i=1:1:node
    sys(node+1)=T_G*h_G(i)*r;
end

W_C=[x(2*node+1:3*node)]';
T_C=10;

for i=1:1:node
    sys(2*node+i)=T_C*h_C(i)*dqr*r;
end

function sys=mdlOutputs(t,x,u)
global node c_D c_C c_G b
qd=u(1);
dqd=u(2);
ddqd=u(3);

q=u(4);
dq=u(5);

for j=1:1:node
    h_D(j)=exp(-norm(q-c_D(:,j))^2/(b*b));
end

for j=1:1:node
    h_G(j)=exp(-norm(q-c_G(:,j))^2/(b*b));
end

z=[q;dq];
for j=1:1:node
    h_C(j)=exp(-norm(z-c_C(:,j))^2/(b*b));
end

W_D=[x(1:node)]';

DSNN_g=[W_D*h_D'];
Dm_g=norm(DSNN_g);

W_G=[x(node+1:2*node)]';

GSNN_g=[W_G*h_G'];
Gm_g=norm(GSNN_g);
    
W_C=[x(2*node+1:3*node)]';

CDNN_g=[W_C*h_C'];
Cm_g=norm(CDNN_g);

e=qd-q;
de=dqd-dq;
Hur=5;
r=de+Hur*e;

dqr=dqd+Hur*e;
ddqr=ddqd+Hur*de;

tolm=DSNN_g*ddqr+CDNN_g*dqr+GSNN_g;

Kr=0.10;
tolr=Kr*sign(r);

Kp=5;
Ki=1.0;

I=u(7);
tol=tolm+Kp*r+Ki*I+tolr;

sys(1)=tol(1);
%sys(2)=Gm_g;
%sys(2)=Dm_g;
sys(2)=Cm_g;