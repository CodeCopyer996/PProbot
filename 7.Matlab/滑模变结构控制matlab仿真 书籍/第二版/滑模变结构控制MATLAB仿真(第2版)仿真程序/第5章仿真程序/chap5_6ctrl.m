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
sizes.NumContStates  = 6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 9;%% 123is command 4-9 is state feedback
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0,0,0,0,0,0];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
epc =10;
x1=u(4);dx1=u(5);
y1=u(6);dy1=u(7);
th=u(8);dth=u(9);

xc=x1-epc*sin(th);
yc=y1+epc*cos(th);

%(8)
p1=xc;
dp1=dx1-epc*cos(th)*dth;
p2=yc;
dp2=dy1-epc*sin(th)*dth;
p3=tan(th);
dp3=1/(cos(th))^2*dth;

q1=p1;q2=dp1;
q3=p2;q4=dp2;
q5=p3;q6=dp3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xd=u(1);
dxd=1;
yd=u(2);
dyd=cos(t);
thd=u(3);
dthd=0;

xcd=xd-epc*sin(thd);
ycd=yd+epc*cos(thd);

p1d = xcd;       
dp1d=dxd-epc*cos(thd)*dthd;
p2d = ycd;
dp2d =dyd-epc*sin(thd)*dthd;
p3d = tan(thd);
dp3d=1/(cos(thd))^2*dthd;

q3d=p2d;
q4d=dp2d;
q5d=p3d;

sys(1)=q4*q5;      %integral of y4y5
sys(2)=x(3);       %Second integral of y3
sys(3)=q3;         %integral of y3
sys(4)=q4d*q5d;
sys(5)=x(6);
sys(6)=q3d;
function sys=mdlOutputs(t,x,u)
epc =10;

xd=u(1);dxd=1;ddxd=0;
yd=u(2);dyd=cos(t);ddyd=-sin(t);
thd=u(3);dthd=0;ddthd=0;

x1=u(4);dx1=u(5);
y1=u(6);dy1=u(7);
th=u(8);dth=u(9);

xc=x1-epc*sin(th);
yc=y1+epc*cos(th);

%(12)
p1=xc;dp1=dx1-epc*cos(th)*dth;
p2=yc;dp2=dy1-epc*sin(th)*dth;
p3=tan(th);dp3=(sec(th))^2*dth;

q1=p1;q2=dp1;
q3=p2;q4=dp2;
q5=p3;q6=dp3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xcd=xd-epc*sin(thd);
ycd=yd+epc*cos(thd);

%(12)
p1d = xcd;dp1d=dxd-epc*cos(thd)*dthd;
ddp1d=ddxd-epc*(-sin(thd)*dthd+cos(thd)*ddthd);

p2d = ycd;dp2d = dyd-epc*sin(thd)*dthd;
ddp2d=ddyd-epc*(cos(thd)*dthd+sin(thd)*ddthd);

p3d = tan(thd);dp3d=1/(cos(thd))^2*dthd;
ddp3d=2*sec(thd)*sec(thd)*tan(thd)*dthd+sec(thd)^2*ddthd;

q1d=p1d;
q3d=p2d;q4d=dp2d;
q5d=p3d;q6d=dp3d;

dq1d=dp1d;
dq2d=ddp1d;
dq3d=dp2d;dq4d=ddp2d;
dq5d=dp3d;dq6d=ddp3d;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z1 = [q1+x(1);x(2)];
z2 = [q2+q4*q5;x(3)];      %dz1=z2
z3 = [q3;q5];
z4 = [q4;q6];              %dz3=z4
z4d = [q4d;q6d];           %dz3=z4

z1d=[q1d+x(4);x(5)];
dz1d=[dq1d+q4d*q5d;x(6)];  %dz1=z2
dz2d=[dq2d+q4d*dq5d+dq4d*q5d;q3d];
dz3d=[dq3d;dq5d];
dz4d=[dq4d;dq6d];

g=9.8;
f1=[q4*q6-g*q5;q3];
f1d =[q4d*q6d-g*q5d;q3d];
f2=[-g;0];
b=[-1,0;0,1];
f1_z3 = [0,-g;1,0];
f1_z3d=f1_z3;

ddz1d=f1d;                  %ddz1=dz2=f1
dddz1d=f1_z3d*z4d;          %dddz1=ddz2=df1
ddddz1d=f1_z3d*dz4d;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c1=27;c2=27;c3=9;
ueq=-inv(f1_z3*b)*(c1*z2-c1*dz1d +c2*f1-c2*ddz1d+c3*f1_z3*z4-c3*dddz1d +f1_z3*f2-ddddz1d);

e1=z1-z1d;
e2=z2-dz1d;
e3=f1-ddz1d;
e4=f1_z3*z4-dddz1d;

s=c1*e1+c2*e2+c3*e3+e4;

M=0.10;
nmn=0.10;

S=2;
if S==1
    sat=sign(s);
elseif S==2         %Saturated function 
   fai=0.1;
   if abs(s)<=fai
      sat=s/fai;
   else
      sat=sign(s);
   end
end
usw=-inv(f1_z3*b)*(M*sat+nmn*s);   
%(17)
h=ueq+usw;

%(10),(11)
v1=h(1)*1/cos(th);
v2=h(2)*(cos(th))^2-2*(dth)^2*tan(th);

%(8)
vm1= (v1-epc*(dth)^2)*sin(th)+epc*v2*cos(th);
vm2=-(v1-epc*(dth)^2)*cos(th)+epc*v2*sin(th)-g;
vm=[vm1;vm2+g];

%(4)
ut=[-sin(th) cos(th);1/epc*cos(th) 1/epc*sin(th)]*vm;

sys(1)=ut(1);
sys(2)=ut(2);