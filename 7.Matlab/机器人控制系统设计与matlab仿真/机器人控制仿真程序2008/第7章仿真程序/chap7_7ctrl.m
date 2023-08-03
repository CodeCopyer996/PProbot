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
global nmn
nmn=10*eye(2);
sizes = simsizes;
sizes.NumContStates  = 10;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.1*ones(10,1)];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
global nmn
qd1=u(1);qd2=u(2);
dqd1=0;dqd2=0;
ddqd1=0;ddqd2=0;
dqd=[dqd1;dqd2];
ddqd=[ddqd1;ddqd2];

q1=u(3);dq1=u(4);
q2=u(5);dq2=u(6);

e1=q1-qd1;
e2=q2-qd2;
e=[e1;e2];
de1=dq1-dqd1;
de2=dq2-dqd2;
de=[de1;de2];
s=de+nmn*e;

fsd1=0;fsd2=0;
for l1=1:1:5
    gs1=-[(s(1)+pi/6-(l1-1)*pi/12)/(pi/24)]^2;
    u1(l1)=exp(gs1);
end
for l1=1:1:5
	fsu1(l1)=u1(l1);
    fsd1=fsd1+u1(l1);
end
fs1=fsu1/(fsd1+0.001);

for l2=1:1:5
    gs2=-[(s(2)+pi/6-(l2-1)*pi/12)/(pi/24)]^2;
    u2(l2)=exp(gs2);
end
for l2=1:1:5
	fsu2(l2)=u2(l2);
    fsd2=fsd2+u2(l2);
end
fs2=fsu2/(fsd2+0.001);

Q1=s(1)*fs1;
Q2=s(2)*fs2;
for i=1:1:5
    sys(i)=Q1(i);
    sys(i+5)=Q2(i);
end

function sys=mdlOutputs(t,x,u)
global nmn
qd1=u(1);qd2=u(2);
dqd1=0;dqd2=0;
ddqd1=0;ddqd2=0;
dqd=[dqd1;dqd2];
ddqd=[ddqd1;ddqd2];

q1=u(3);dq1=u(4);
q2=u(5);dq2=u(6);
dq=[dq1;dq2];

e1=q1-qd1;
e2=q2-qd2;
e=[e1;e2];
de1=dq1-dqd1;
de2=dq2-dqd2;
de=[de1;de2];

% The model is given by Slotine and Weiping Li(MIT 1987)
alfa=6.7;beta=3.4;
epc=3.0;eta=0;
m1=1;l1=1;
lc1=1/2;I1=1/12;
g=9.8;
e1=m1*l1*lc1-I1-m1*l1^2;
e2=g/l1;
M=[alfa+2*epc*cos(q2)+2*eta*sin(q2),beta+epc*cos(q2)+eta*sin(q2);
   beta+epc*cos(q2)+eta*sin(q2),beta];
C=[(-2*epc*sin(q2)+2*eta*cos(q2))*dq2,(-epc*sin(q2)+eta*cos(q2))*dq2;
   (epc*sin(q2)-eta*cos(q2))*dq1,0];
G=[epc*e2*cos(q1+q2)+eta*e2*sin(q1+q2)+(alfa-beta+e1)*e2*cos(q1);
   epc*e2*cos(q1+q2)+eta*e2*sin(q1+q2)];
M0=0.5*M;
C0=0.5*C;
G0=0.5*G;

s=de+nmn*e;
dqr=dqd-nmn*e;
ddqr=ddqd-nmn*de;
for i=1:1:5
    thta1(i,1)=x(i);
end
for i=1:1:5
    thta2(i,1)=x(i+5);
end

fsd1=0;fsd2=0;
for l1=1:1:5
    gs1=-[(s(1)+pi/6-(l1-1)*pi/12)/(pi/24)]^2;
    u1(l1)=exp(gs1);
end
for l1=1:1:5
	fsu1(l1)=u1(l1);
    fsd1=fsd1+u1(l1);
end
fs1=fsu1/(fsd1+0.001);
k1=thta1'*fs1';

for l2=1:1:5
    gs2=-[(s(2)+pi/6-(l2-1)*pi/12)/(pi/24)]^2;
    u2(l2)=exp(gs2);
end
for l2=1:1:5
	fsu2(l2)=u2(l2);
    fsd2=fsd2+u2(l2);
end
fs2=fsu2/(fsd2+0.001);

k2=thta2'*fs2';

A=150*eye(2);
S=2;
if S==1
    K=[100 0;100 0];;
    tol=M0*ddqr+C0*dqr+G0-A*s-K*sign(s);
elseif S==2    %Adaptive fuzzy gain
    K=1*[k1 k2]';
    tol=M0*ddqr+C0*dqr+G0-A*s-K;
end
sys(1)=tol(1);
sys(2)=tol(2);
sys(3)=K(1);
sys(4)=K(2);