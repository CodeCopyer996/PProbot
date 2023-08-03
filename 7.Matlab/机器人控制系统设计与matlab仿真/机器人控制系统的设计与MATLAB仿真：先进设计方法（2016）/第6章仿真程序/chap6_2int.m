clear all;
close all;
I=1.0;J=1.0;Mgl=5.0;K=40;
b1=K/I;b2=Mgl/I;b3=1/J;b4=K/J;

x10=0.1;x20=0;x30=0;x40=0;
c1=5;c2=45;c3=25;c4=5;

x1d0=0;dx1d0=1;   %x1d=sint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z10=x10-x1d0;
x2_bar0=-c1*z10+dx1d0;
x2d0=x2_bar0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dx2d0=0;   %x2d(0)=x2_bar(0)
z20=x20-x2d0;
f20=-x10;

x3_bar0=1/b1*(b2*sin(x10)+dx2d0-c2*z20)-f20;
x3d0=x3_bar0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z30=x30-x3d0;
dx3d0=0;   %x3d(0)=x3_bar(0)
x4_bar0=-c3*z30+dx3d0;
x4d0=x4_bar0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z40=x40-x4d0;
y20=x2d0-x2_bar0;
y30=x3d0-x3_bar0;
y40=x4d0-x4_bar0;
V0=0.5*(z10^2+z20^2+z30^2+z40^2)+0.5*(y20^2+y30^2+y40^2);
p=V0+0.10;        %p>=V0
r=1.5/(2*p)+0.10  %r>=1.5/(2*p);

1+r        %c1>=1+r
1/2+b1+r   %c2>=1/2+b1+r
1+b1/2+r   %c3>=1+b1/2+r
0.5+r      %c4>=0.5+r