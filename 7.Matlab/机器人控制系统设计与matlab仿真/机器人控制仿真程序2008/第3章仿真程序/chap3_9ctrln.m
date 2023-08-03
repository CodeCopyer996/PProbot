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
global node c_M c_V c_G c_F b Fai
node=5;
c_M= [-1 -0.5 0 0.5 1;
      -1 -0.5 0 0.5 1];
c_V=[-1 -0.5 0 0.5 1;
     -1 -0.5 0 0.5 1;
     -1 -0.5 0 0.5 1; 
     -1 -0.5 0 0.5 1];
c_G=[-1 -0.5 0 0.5 1;    
     -1 -0.5 0 0.5 1];
c_F=[-1 -0.5 0 0.5 1;    
     -1 -0.5 0 0.5 1];
b=10;
Fai=5*eye(2);

sizes = simsizes;
sizes.NumContStates  = 12*node;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 11;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = zeros(1,12*node);
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global node c_M c_V c_G c_F b Fai
qd1=u(1);
d_qd1=u(2);
dd_qd1=u(3);
qd2=u(4);
d_qd2=u(5);
dd_qd2=u(6);

q1=u(7);
d_q1=u(8);
q2=u(9);
d_q2=u(10);

q=[q1;q2];
for j=1:1:node
    h_M11(j)=exp(-norm(q-c_M(:,j))^2/(b*b));
    h_M12(j)=exp(-norm(q-c_M(:,j))^2/(b*b));
    h_M21(j)=exp(-norm(q-c_M(:,j))^2/(b*b));
    h_M22(j)=exp(-norm(q-c_M(:,j))^2/(b*b));
end

z=[q1;q2;d_q1;d_q2];
for j=1:1:node
    h_V11(j)=exp(-norm(z-c_V(:,j))^2/(b*b));
    h_V12(j)=exp(-norm(z-c_V(:,j))^2/(b*b));
    h_V21(j)=exp(-norm(z-c_V(:,j))^2/(b*b));
    h_V22(j)=exp(-norm(z-c_V(:,j))^2/(b*b));
end

for j=1:1:node
    h_G1(j)=exp(-norm(q-c_G(:,j))^2/(b*b));
    h_G2(j)=exp(-norm(q-c_G(:,j))^2/(b*b));
end

dq=[d_q1;d_q2];
for j=1:1:node
    h_F1(j)=exp(-norm(dq-c_F(:,j))^2/(b*b));
    h_F2(j)=exp(-norm(dq-c_F(:,j))^2/(b*b));
end

F_M11=5*eye(node);
F_M12=5*eye(node);
F_M21=5*eye(node);
F_M22=5*eye(node);

e1=qd1-q1;
e2=qd2-q2;
de1=d_qd1-d_q1;
de2=d_qd2-d_q2;
e=[e1;e2];
de=[de1;de2];
r=de+Fai*e;

dqd=[d_qd1;d_qd2];
dqr=dqd+Fai*e;
ddqd=[dd_qd1;dd_qd2];
ddqr=ddqd+Fai*de;

k=0.01;
for i=1:1:node
    sys(i)=F_M11(i,i)*h_M11(i)*r(1)*r(1)-k*F_M11(i,i)*norm(r)*x(i);
    sys(i+node)=F_M12(i,i)*h_M12(i)*r(2)*r(1)-k*F_M12(i,i)*norm(r)*x(i+node);
    sys(i+node*2)=F_M21(i,i)*h_M21(i)*r(1)*r(2)-k*F_M12(i,i)*norm(r)*x(i+node*2);
    sys(i+node*3)=F_M22(i,i)*h_M22(i)*r(2)*r(2)-k*F_M12(i,i)*norm(r)*x(i+node*3);
end

F_G1=10*eye(node);
F_G2=10*eye(node);
for i=1:1:node
    sys(i+node*4)=F_G1(i,i)*h_G1(i)*r(1)-k*F_G1(i,i)*norm(r)*x(i+node*4);
    sys(i+node*5)=F_G2(i,i)*h_G2(i)*r(2)-k*F_G2(i,i)*norm(r)*x(i+node*5);
end

F_V11=10*eye(node);
F_V12=10*eye(node);
F_V21=10*eye(node);
F_V22=10*eye(node);
for i=1:1:node
    sys(i+node*6)=F_V11(i,i)*h_V11(i)*r(1)*r(1)-k*F_V11(i,i)*norm(r)*x(i+node*6);
    sys(i+node*7)=F_V12(i,i)*h_V12(i)*r(2)*r(1)-k*F_V12(i,i)*norm(r)*x(i+node*7);
    sys(i+node*8)=F_V21(i,i)*h_V21(i)*r(1)*r(2)-k*F_V21(i,i)*norm(r)*x(i+node*8);
    sys(i+node*9)=F_V22(i,i)*h_V22(i)*r(2)*r(2)-k*F_V22(i,i)*norm(r)*x(i+node*9);
end

F_F1=10*eye(node);
F_F2=10*eye(node);
for i=1:1:node
    sys(i+node*10)=F_F1(i,i)*h_F1(i)*r(1)-k*F_F1(i,i)*norm(r)*x(i+node*10);
    sys(i+node*11)=F_F2(i,i)*h_F2(i)*r(2)-k*F_F2(i,i)*norm(r)*x(i+node*11);
end
function sys=mdlOutputs(t,x,u)
global node c_M c_V c_G c_F b Fai
qd1=u(1);
d_qd1=u(2);
dd_qd1=u(3);
qd2=u(4);
d_qd2=u(5);
dd_qd2=u(6);
dqd=[d_qd1;d_qd2];
ddqd=[dd_qd1;dd_qd2];

q1=u(7);
d_q1=u(8);
q2=u(9);
d_q2=u(10);

e1=qd1-q1;
e2=qd2-q2;
de1=d_qd1-d_q1;
de2=d_qd2-d_q2;
e=[e1;e2];
de=[de1;de2];
r=de+Fai*e;

q1=u(7);
d_q1=u(8);
q2=u(9);
d_q2=u(10);

q=[q1;q2];
for j=1:1:node
    h_M11(j)=exp(-norm(q-c_M(:,j))^2/(b*b));
    h_M12(j)=exp(-norm(q-c_M(:,j))^2/(b*b));
    h_M21(j)=exp(-norm(q-c_M(:,j))^2/(b*b));
    h_M22(j)=exp(-norm(q-c_M(:,j))^2/(b*b));
end

z=[q1;q2;d_q1;d_q2];
for j=1:1:node
    h_V11(j)=exp(-norm(z-c_V(:,j))^2/(b*b));
    h_V12(j)=exp(-norm(z-c_V(:,j))^2/(b*b));
    h_V21(j)=exp(-norm(z-c_V(:,j))^2/(b*b));
    h_V22(j)=exp(-norm(z-c_V(:,j))^2/(b*b));
end

for j=1:1:node
    h_G1(j)=exp(-norm(q-c_G(:,j))^2/(b*b));
    h_G2(j)=exp(-norm(q-c_G(:,j))^2/(b*b));
end
dq=[d_q1;d_q2];
for j=1:1:node
    h_F1(j)=exp(-norm(dq-c_F(:,j))^2/(b*b));
    h_F2(j)=exp(-norm(dq-c_F(:,j))^2/(b*b));
end

W_M11=[x(1:node)]';
W_M12=[x(node+1:node*2)]';
W_M21=[x(node*2+1:node*3)]';
W_M22=[x(node*3+1:node*4)]';

W_G1=[x(node*4+1:node*5)]';
W_G2=[x(node*5+1:node*6)]';

W_V11=[x(node*6+1:node*7)]';
W_V12=[x(node*7+1:node*8)]';
W_V21=[x(node*8+1:node*9)]';
W_V22=[x(node*9+1:node*10)]';

W_F1=[x(node*10+1:node*11)]';
W_F2=[x(node*11+1:node*12)]';

M=[W_M11*h_M11' W_M12*h_M12';
   W_M21*h_M21' W_M22*h_M22'];
G=[W_G1*h_G1';
   W_G2*h_G2'];
Vm=[W_V11*h_V11' W_V12*h_V12';
    W_V21*h_V21' W_V22*h_V22'];
F=[W_F1*h_F1';
   W_F2*h_F2'];

Kesi1=ddqd+Fai*de;
Kesi2=dqd+Fai*e;
fn=M*Kesi1+Vm*Kesi2+G+F;

Kv=20*eye(2);
epN=[1.0 0;0 0.20];
bd=0.1*eye(2);
v=-(epN+bd)*sign(r);
tol=fn+Kv*r-v;

fn_norm=norm(fn);

sys(1)=tol(1);
sys(2)=tol(2);
sys(3)=fn_norm;