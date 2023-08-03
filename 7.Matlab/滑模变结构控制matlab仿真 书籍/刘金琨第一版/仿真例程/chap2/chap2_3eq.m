function dx=DxnamicModel(t,x,flag,para)
global C M0 F

M=5;m=1;a=1;C1=1;g=9.81;
a32=-3*(C1-m*g*a)/(a*(4*M+m));
a42=-3*(M+m)*(C1-m*g*a)/(a^2*m*(4*M+m));
b3=4/(4*M+m);
b4=3/(4*M+m);
A=[0,0,1,0;
   0,0,0,1;
   0,a32,0,0;
   0,a42,0,0];
b=[0;0;b3;b4];

%Ackermann's formula
n1=-1;n2=-2;n3=-3;
C=[0,0,0,1]*inv([b,A*b,A^2*b,A^3*b])*(A-n1*eye(4))*(A-n2*eye(4))*(A-n3*eye(4));
s=C*x;

F=2;
if F==1
   M0=40;
   u=-M0*sign(s);
elseif F==2
	beta=30;
   delta=0;
   u=-beta*(abs(x(1))+abs(x(2))+abs(x(3))+abs(x(4))+delta)*sign(s);
end

%State equation
dx=zeros(4,1);
f0=0.5;
ft=f0*sin(3*t);

dx=A*x+b*(u+ft);