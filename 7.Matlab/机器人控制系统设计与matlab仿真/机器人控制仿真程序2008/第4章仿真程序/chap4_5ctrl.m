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
sizes = simsizes;
sizes.NumContStates  = 6*3^4+1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);

for i=1:6*3^4
   x0(i) = 0;
end
x0(6*3^4+1)=1.0;
   
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
yd1=u(1);
yd2=u(2);
dyd1=cos(t);
dyd2=cos(t);
ddyd1=-sin(t);
ddyd2=-sin(t);

x1=u(3);x2=u(4);
x3=u(5);x4=u(6);

e1=yd1-x1;
e2=yd2-x3;
de1=dyd1-x2;
de2=dyd2-x4;

nmn1=25;nmn2=25;
beta11=nmn1;beta21=nmn2;
K0=15*eye(2);

v1=ddyd1+beta11*de1;
v2=ddyd2+beta21*de2;
v=[v1 v2]';

s1=de1+nmn1*e1;
s2=de2+nmn2*e2;
s=[s1 s2]';

%Control law (26)
ep0=0.2;
delta=x(6*3^4+1);
Ip=eye(2);

up_f=0.2;up_g=0.2;up_u=0.2;
rou0=0.2;

u1(1)=exp(-1/2*((x(1)+1.25)/0.6)^2);
u1(2)=exp(-1/2*(x(1)/0.6)^2);
u1(3)=exp(-1/2*((x(1)-1.25)/0.6)^2);

u2(1)=exp(-1/2*((x(2)+1.25)/0.6)^2);
u2(2)=exp(-1/2*(x(2)/0.6)^2);
u2(3)=exp(-1/2*((x(2)-1.25)/0.6)^2);

u3(1)=exp(-1/2*((x(3)+1.25)/0.6)^2);
u3(2)=exp(-1/2*(x(3)/0.6)^2);
u3(3)=exp(-1/2*((x(3)-1.25)/0.6)^2);

u4(1)=exp(-1/2*((x(4)+1.25)/0.6)^2);
u4(2)=exp(-1/2*(x(4)/0.6)^2);
u4(3)=exp(-1/2*((x(4)-1.25)/0.6)^2);

FS1=0;
FS2=zeros(3^4,1);
for L1=1:3
    for L2=1:3
        for L3=1:3
            for L4=1:3
                FS2(3^3*(L1-1)+3^2*(L2-1)+3*(L3-1)+L4)=u1(L1)*u2(L2)*u3(L3)*u4(L4);
                FS1=FS1+u1(L1)*u2(L2)*u3(L3)*u4(L4);
            end
        end
    end
end
FS=FS2/FS1;

w_f1=FS;w_f2=FS;
w_g11=FS;w_g12=FS;
w_g21=FS;w_g22=FS;

thtaf1=x(1:3^4);
thtaf2=x((3^4+1):(3^4*2));
thtag11=x((3^4*2+1):(3^4*3));
thtag12=x((3^4*3+1):(3^4*4));
thtag21=x((3^4*4+1):(3^4*5));
thtag22=x((3^4*5+1):(3^4*6));

f1=w_f1'*thtaf1;
f2=w_f2'*thtaf2;

g11=w_g11'*thtag11;
g12=w_g12'*thtag12;
g21=w_g21'*thtag21;
g22=w_g22'*thtag22;

F=[f1 f2]';
G=[g11 g12;g21 g22];

uc=G'*inv(ep0*Ip+G*G')*(-F+v+K0*s);
u0=ep0*inv(ep0*Ip+G*G')*(-F+v+K0*s);
ur=s*abs(s')*(up_f+up_g*abs(uc)+abs(u0))/(rou0*(norm(s))^2+delta);

xite_f1=0.5;
xite_f2=0.5;
xite_g11=0.5;
xite_g12=0.5;
xite_g21=0.5;
xite_g22=0.5;
xite0=0.001;

for i=1:1:3^4
    sys(i)=-xite_f1*w_f1(i)*s(1);
end
for i=3^4+1:1:2*3^4
    sys(i)=-xite_f2*w_f2(i-3^4)*s(2);
end
for i=2*3^4+1:1:3*3^4
    sys(i)=-xite_g11*w_g11(i-2*3^4)*s(1)*uc(1);
end
for i=3*3^4+1:1:4*3^4
    sys(i)=-xite_g12*w_g12(i-3*3^4)*s(1)*uc(2);
end
for i=4*3^4+1:1:5*3^4
    sys(i)=-xite_g21*w_g21(i-4*3^4)*s(2)*uc(1);
end
for i=5*3^4+1:1:6*3^4
    sys(i)=-xite_g22*w_g22(i-5*3^4)*s(2)*uc(2);
end

sys(6*3^4+1)=-xite0*(abs(s')*(up_f+up_g*abs(uc)+abs(u0)))/(rou0*norm(s)^2+delta);

function sys=mdlOutputs(t,x,u)
yd1=u(1);
yd2=u(2);
dyd1=cos(t);
dyd2=cos(t);
ddyd1=-sin(t);
ddyd2=-sin(t);

x1=u(3);x2=u(4);
x3=u(5);x4=u(6);

e1=yd1-x1;
e2=yd2-x3;
de1=dyd1-x2;
de2=dyd2-x4;

nmn1=25;nmn2=25;
beta11=nmn1;beta21=nmn2;
K0=15*eye(2);

v1=ddyd1+beta11*de1;
v2=ddyd2+beta21*de2;
v=[v1 v2]';

s1=de1+nmn1*e1;
s2=de2+nmn2*e2;
s=[s1 s2]';

%Control law (26)
ep0=0.2;
delta=x(6*3^4+1);
Ip=eye(2);

up_f=0.2;up_g=0.2;up_u=0.2;
rou0=0.2;

u1(1)=exp(-1/2*((x(1)+1.25)/0.6)^2);
u1(2)=exp(-1/2*(x(1)/0.6)^2);
u1(3)=exp(-1/2*((x(1)-1.25)/0.6)^2);

u2(1)=exp(-1/2*((x(2)+1.25)/0.6)^2);
u2(2)=exp(-1/2*(x(2)/0.6)^2);
u2(3)=exp(-1/2*((x(2)-1.25)/0.6)^2);

u3(1)=exp(-1/2*((x(3)+1.25)/0.6)^2);
u3(2)=exp(-1/2*(x(3)/0.6)^2);
u3(3)=exp(-1/2*((x(3)-1.25)/0.6)^2);

u4(1)=exp(-1/2*((x(4)+1.25)/0.6)^2);
u4(2)=exp(-1/2*(x(4)/0.6)^2);
u4(3)=exp(-1/2*((x(4)-1.25)/0.6)^2);

FS1=0;
FS2=zeros(3^4,1);
for L1=1:3
    for L2=1:3
        for L3=1:3
            for L4=1:3
                FS2(3^3*(L1-1)+3^2*(L2-1)+3*(L3-1)+L4)=u1(L1)*u2(L2)*u3(L3)*u4(L4);
                FS1=FS1+u1(L1)*u2(L2)*u3(L3)*u4(L4);
            end
        end
    end
end
FS=FS2/FS1;

w_f1=FS;w_f2=FS;
w_g11=FS;w_g12=FS;
w_g21=FS;w_g22=FS;

thtaf1=x(1:3^4);
thtaf2=x((3^4+1):(3^4*2));
thtag11=x((3^4*2+1):(3^4*3));
thtag12=x((3^4*3+1):(3^4*4));
thtag21=x((3^4*4+1):(3^4*5));
thtag22=x((3^4*5+1):(3^4*6));

f1=w_f1'*thtaf1;
f2=w_f2'*thtaf2;

g11=w_g11'*thtag11;
g12=w_g12'*thtag12;
g21=w_g21'*thtag21;
g22=w_g22'*thtag22;

F=[f1 f2]';
G=[g11 g12;g21 g22];

uc=G'*inv(ep0*Ip+G*G')*(-F+v+K0*s);
u0=ep0*inv(ep0*Ip+G*G')*(-F+v+K0*s);
ur=s*abs(s')*(up_f+up_g*abs(uc)+abs(u0))/(rou0*(norm(s))^2+delta);
ut=uc+ur;

sys(1)=ut(1);
sys(2)=ut(2);