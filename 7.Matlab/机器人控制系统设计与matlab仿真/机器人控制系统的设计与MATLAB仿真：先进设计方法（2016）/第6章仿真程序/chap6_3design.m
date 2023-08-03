clear all;
close all;

A=[0 1 0 0;
   0 0 1 0;
   0 0 0 1;
   0 0 0 0];
c=[1 0 0 0];

a=5;

k1=4*a;
k2=6*a^2;
k3=4*a^3;
k4=a^4;

k=[k1 k2 k3 k4]'

A0=A-k*c;
eig(A0)