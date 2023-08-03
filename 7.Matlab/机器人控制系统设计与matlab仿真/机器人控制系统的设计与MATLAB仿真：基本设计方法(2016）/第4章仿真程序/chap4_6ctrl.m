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
global nmn1 nmn2 Fai
nmn1=5;nmn2=5;
Fai=[nmn1 0;0 nmn2];
sizes = simsizes;
sizes.NumContStates  = 4*5^4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0.1*ones(4*5^4,1)];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global nmn1 nmn2 Fai
qd1=u(1);
qd2=u(2);
dqd1=0.3*cos(t);
dqd2=0.3*cos(t);
dqd=[dqd1 dqd2]';

ddqd1=-0.3*sin(t);
ddqd2=-0.3*sin(t);
ddqd=[ddqd1 ddqd2]';

q1=u(3);dq1=u(4);
q2=u(5);dq2=u(6);
ddq1=u(9);ddq2=u(10);

for l1=1:1:5
    gs1=-[(q1+pi/6-(l1-1)*pi/12)/(pi/24)]^2;
	u1(l1)=exp(gs1);
end
for l2=1:1:5
    gs2=-[(dq1+pi/6-(l2-1)*pi/12)/(pi/24)]^2;
    u2(l2)=exp(gs2);
end
for l3=1:1:5
    gs3=-[(q2+pi/6-(l3-1)*pi/12)/(pi/24)]^2;
	u3(l3)=exp(gs3);
end
for l4=1:1:5
    gs4=-[(dq2+pi/6-(l4-1)*pi/12)/(pi/24)]^2;
    u4(l4)=exp(gs4);
end

for l5=1:1:5
    gs5=-[(ddq1+pi/6-(l5-1)*pi/12)/(pi/24)]^2;
	u5(l5)=exp(gs5);
end
for l6=1:1:5
    gs6=-[(ddq2+pi/6-(l6-1)*pi/12)/(pi/24)]^2;
    u6(l6)=exp(gs6);
end

fsd=0;
fsu=zeros(5^4,1);
for l1=1:5
    for l2=1:5
        for l3=1:5
            for l4=1:5
                fsu(5^3*(l1-1)+5^2*(l2-1)+5*(l3-1)+l4)=u1(l1)*u2(l2)*u3(l3)*u4(l4);
                fsd=fsd+u1(l1)*u2(l2)*u3(l3)*u4(l4);
             end
        end
    end
end
fs=fsu/(fsd+0.001);

fsd1=0;
fsu1=zeros(5^4,1);
for l1=1:5
    for l2=1:5
        for l5=1:5
            for l6=1:5
                fsu1(5^3*(l1-1)+5^2*(l2-1)+5*(l5-1)+l6)=u1(l1)*u2(l2)*u5(l5)*u6(l6);
                fsd1=fsd1+u1(l1)*u2(l2)*u5(l5)*u6(l6);
             end
        end
    end
end
fs1=fsu1/(fsd1+0.001);

e1=q1-qd1;
e2=q2-qd2;
e=[e1 e2]';
de1=dq1-dqd1;
de2=dq2-dqd2;
de=[de1 de2]';

s=de+Fai*e;
Gama11=0.01;Gama12=0.01;
Gama21=0.01;Gama22=0.01;

S11=-1/Gama11*s(1)*fs;
S12=-1/Gama12*s(2)*fs;
S21=-1/Gama21*s(1)*fs1;
S22=-1/Gama22*s(2)*fs1;
for i=1:1:5^4
    sys(i)=S11(i);
end
for j=5^4+1:1:2*5^4
    sys(j)=S12(j-5^4);
end
for j=2*5^4+1:1:3*5^4
    sys(j)=S21(j-2*5^4);
end
for j=3*5^4+1:1:4*5^4
    sys(j)=S22(j-3*5^4);
end

function sys=mdlOutputs(t,x,u)
global nmn1 nmn2 Fai
qd1=u(1);
qd2=u(2);
dqd1=0.3*cos(t);
dqd2=0.3*cos(t);
dqd=[dqd1 dqd2]';

ddqd1=-0.3*sin(t);
ddqd2=-0.3*sin(t);
ddqd=[ddqd1 ddqd2]';

q1=u(3);dq1=u(4);
q2=u(5);dq2=u(6);
ddq1=u(9);ddq2=u(10);

for l1=1:1:5
    gs1=-[(q1+pi/6-(l1-1)*pi/12)/(pi/24)]^2;
	u1(l1)=exp(gs1);
end
for l2=1:1:5
    gs2=-[(dq1+pi/6-(l2-1)*pi/12)/(pi/24)]^2;
    u2(l2)=exp(gs2);
end
for l3=1:1:5
    gs3=-[(q2+pi/6-(l3-1)*pi/12)/(pi/24)]^2;
	u3(l3)=exp(gs3);
end
for l4=1:1:5
    gs4=-[(dq2+pi/6-(l4-1)*pi/12)/(pi/24)]^2;
    u4(l4)=exp(gs4);
end

for l5=1:1:5
    gs5=-[(ddq1+pi/6-(l5-1)*pi/12)/(pi/24)]^2;
	u5(l5)=exp(gs5);
end
for l6=1:1:5
    gs6=-[(ddq2+pi/6-(l6-1)*pi/12)/(pi/24)]^2;
    u6(l6)=exp(gs6);
end

fsd=0;
fsu=zeros(5^4,1);
for l1=1:5
    for l2=1:5
        for l3=1:5
            for l4=1:5
                fsu(5^3*(l1-1)+5^2*(l2-1)+5*(l3-1)+l4)=u1(l1)*u2(l2)*u3(l3)*u4(l4);
                fsd=fsd+u1(l1)*u2(l2)*u3(l3)*u4(l4);
             end
        end
    end
end
fs=fsu/(fsd+0.001);

fsd1=0;
fsu1=zeros(5^4,1);
for l1=1:5
    for l2=1:5
        for l5=1:5
            for l6=1:5
                fsu1(5^3*(l1-1)+5^2*(l2-1)+5*(l5-1)+l6)=u1(l1)*u2(l2)*u5(l5)*u6(l6);
                fsd1=fsd1+u1(l1)*u2(l2)*u5(l5)*u6(l6);
             end
        end
    end
end
fs1=fsu1/(fsd1+0.001);

e1=q1-qd1;
e2=q2-qd2;
e=[e1 e2]';
de1=dq1-dqd1;
de2=dq2-dqd2;
de=[de1 de2]';

s=de+Fai*e;
dqr=dqd-Fai*e;
ddqr=ddqd-Fai*de;

for i=1:1:5^4
    thta1(i,1)=x(i);
end
for i=1:1:5^4
    thta2(i,1)=x(i+5^4);
end
for i=1:1:5^4
    thta3(i,1)=x(i+2*5^4);
end
for i=1:1:5^4
    thta4(i,1)=x(i+3*5^4);
end
%///////////////////////
r1=1;r2=0.8;
m1=1;m2=0.8;

D11=(m1+m2)*r1^2+m2*r2^2+2*m2*r1*r2*cos(q2);
D22=m2*r2^2;
D21=m2*r2^2+m2*r1*r2*cos(q2);
D12=D21;
D=[D11 D12;D21 D22];

C12=m2*r1*sin(q2);
C=[-C12*dq2 -C12*(dq1+dq2);C12*q1 0];

g1=(m1+m2)*r1*cos(q2)+m2*r2*cos(q1+q2);
g2=m2*r2*cos(q1+q2);
G=[g1;g2];

Fp11=thta1'*fs;
Fp12=thta2'*fs;
Fp21=thta3'*fs1;
Fp22=thta4'*fs1;

Fp1=[Fp11 Fp12]';
Fp2=[Fp21 Fp22]';

KD=10*eye(2);
W=[2 0;0 2];

M=1;
if M==1
    tol=D*ddqr+C*dqr+G+Fp1+Fp2-KD*s;             % (4.142)
elseif M==2
    tol=D*ddqr+C*dqr+G+Fp1+Fp2-KD*s-W*sign(s);   % (4.145)
end
sys(1)=tol(1);
sys(2)=tol(2);
sys(3)=Fp1(1)+Fp2(1);
sys(4)=Fp1(2)+Fp2(2);