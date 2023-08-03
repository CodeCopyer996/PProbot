clear all;
close all;

x1=0.1;
x1d=0;
dx1d=1;
v1=0;

v2_bar=0          %x2_bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l2=25;k2=54;

v2d=v2_bar;   %x2d(0)=x2_bar(0)
v2=0;
s2=v2-v2d;
tol2=0.01;

dv2d=(v2_bar-v2d)/tol2;

v3_bar=-l2*s2+k2*v1+dv2d   %x3_bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v3d=v3_bar;  %x3d(0)=x3_bar(0)

tol3=0.01;
dv3d=(v3_bar-v3d)/tol3;

v3=0;k3=108;
s3=v3-v3d;
l3=5;
v4_bar=dv3d+k3*v1-l3*s3           %x4_bar