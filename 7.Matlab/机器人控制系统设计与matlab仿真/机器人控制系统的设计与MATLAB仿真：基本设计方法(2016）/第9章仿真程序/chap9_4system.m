function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
global J Fx
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 8;
sizes.NumInputs      = 8;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.8 0 1.0 0];   %x(0)=xc(0)
str=[];
ts=[];
J=0;Dx=0;Cx=0;Gx=0;Fx=[0 0];
function sys=mdlDerivatives(t,x,u)
global J Fx
xd1=u(1);dxd1=u(2);ddxd1=u(3);
xd2=u(4);dxd2=u(5);ddxd2=u(6);

Fe1=u(7);Fe2=u(8);
Fe=[Fe1 Fe2]';

l1=1;l2=1;
P=[1.66 0.42 0.63 3.75 1.25];
g=9.8;
L=[l1^2 l2^2 l1*l2 l1 l2];

pl=0.5;

M=P+pl*L;
Q=(x(1)^2+x(3)^2-l1^2-l2^2)/(2*l1*l2);
q2=acos(Q);
dq2=-1/sqrt(1-Q^2);

A=x(3)/x(1);
p1=atan(A);
d_p1=1/(1+A^2);

B=sqrt(x(1)^2+x(3)^2+l1^2-l2^2)/(2*l1*sqrt(x(1)^2+x(3)^2));
p2=acos(B);
d_p2=-1/sqrt(1-B^2);

if q2>0
    q1=p1-p2;
    dq1=d_p1-d_p2;
else
    q1=p1+p2;
    dq1=d_p1+d_p2;
end
J=[-sin(q1)-sin(q1+q2) -sin(q1+q2);
    cos(q1)+cos(q1+q2) cos(q1+q2)];
d_J=[-dq1*cos(q1)-(dq1+dq2)*cos(q1+q2) -(dq1+dq2)*cos(q1+q2);
    -dq1*sin(q1)-(dq1+dq2)*sin(q1+q2) -(dq1+dq2)*sin(q1+q2)];

D=[M(1)+M(2)+2*M(3)*cos(q2) M(2)+M(3)*cos(q2);
    M(2)+M(3)*cos(q2) M(2)];
C=[-M(3)*dq2*sin(q2) -M(3)*(dq1+dq2)*sin(q2);
    M(3)*dq1*sin(q2)  0];
G=[M(4)*g*cos(q1)+M(5)*g*cos(q1+q2);
   M(5)*g*cos(q1+q2)];

Dx=(inv(J))'*D*inv(J);
Cx=(inv(J))'*(C-D*inv(J)*d_J)*inv(J);
Gx=(inv(J))'*G;

e1=xd1-x(1);
e2=xd2-x(3);
de1=dxd1-x(2);
de2=dxd2-x(4);
e=[e1;e2];
de=[de1;de2];

Hur=15.0*eye(2);
r=de+Hur*e;

dxd=[dxd1;dxd2];
dxr=dxd+Hur*e;
ddxd=[ddxd1;ddxd2];
ddxr=ddxd+Hur*de;

K=15*eye(2);
epc=0.50;
xite=1.2;
Fx=Dx*ddxr+Cx*dxr+Gx+K*r+Fe+xite*tanh(r/epc);

Delta=1.0*sin(t);
dx=[x(2);x(4)];
S=inv(Dx)*(Fx-Cx*dx-Gx-Delta);
sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
global J Fx
xd1=u(1);dxd1=u(2);ddxd1=u(3);
xd2=u(4);dxd2=u(5);ddxd2=u(6);

Fe1=u(7);Fe2=u(8);
Fe=[Fe1 Fe2]';

l1=1;l2=1;
P=[1.66 0.42 0.63 3.75 1.25];
g=9.8;
L=[l1^2 l2^2 l1*l2 l1 l2];

pl=0.5;

M=P+pl*L;
Q=(x(1)^2+x(3)^2-l1^2-l2^2)/(2*l1*l2);
q2=acos(Q);
dq2=-1/sqrt(1-Q^2);

A=x(3)/x(1);
p1=atan(A);
d_p1=1/(1+A^2);

B=sqrt(x(1)^2+x(3)^2+l1^2-l2^2)/(2*l1*sqrt(x(1)^2+x(3)^2));
p2=acos(B);
d_p2=-1/sqrt(1-B^2);

if q2>0
    q1=p1-p2;
    dq1=d_p1-d_p2;
else
    q1=p1+p2;
    dq1=d_p1+d_p2;
end
J=[-sin(q1)-sin(q1+q2) -sin(q1+q2);
    cos(q1)+cos(q1+q2) cos(q1+q2)];
d_J=[-dq1*cos(q1)-(dq1+dq2)*cos(q1+q2) -(dq1+dq2)*cos(q1+q2);
    -dq1*sin(q1)-(dq1+dq2)*sin(q1+q2) -(dq1+dq2)*sin(q1+q2)];

D=[M(1)+M(2)+2*M(3)*cos(q2) M(2)+M(3)*cos(q2);
    M(2)+M(3)*cos(q2) M(2)];
C=[-M(3)*dq2*sin(q2) -M(3)*(dq1+dq2)*sin(q2);
    M(3)*dq1*sin(q2)  0];
G=[M(4)*g*cos(q1)+M(5)*g*cos(q1+q2);
   M(5)*g*cos(q1+q2)];

Dx=(inv(J))'*D*inv(J);
Cx=(inv(J))'*(C-D*inv(J)*d_J)*inv(J);
Gx=(inv(J))'*G;

e1=xd1-x(1);
e2=xd2-x(3);
de1=dxd1-x(2);
de2=dxd2-x(4);
e=[e1;e2];
de=[de1;de2];

Hur=15.0*eye(2);
r=de+Hur*e;

dxd=[dxd1;dxd2];
dxr=dxd+Hur*e;
ddxd=[ddxd1;ddxd2];
ddxr=ddxd+Hur*de;

K=15*eye(2);
epc=0.50;
xite=1.2;
Fx=Dx*ddxr+Cx*dxr+Gx+K*r+Fe+xite*tanh(r/epc);

Delta=1.0*sin(t);
dx=[x(2);x(4)];
S=inv(Dx)*(Fx-Cx*dx-Gx-Delta);

tol=J'*Fx;

sys(1)=x(1);
sys(2)=x(2);
sys(3)=S(1);
sys(4)=x(3);
sys(5)=x(4);
sys(6)=S(2);
sys(7:8)=tol(1:2);