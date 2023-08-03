clear all;
close all;

J=1/133;b=25/133;
A=[0 1;
   0 -b/J];
B=[0 1/J]';

F=sdpvar(1,2);
P=sdpvar(2,2,'symmetric');
N=sdpvar(2,2,'symmetric');

%First LMI
gama=10;
M=[A*N+B*F+N*A'+F'*B' B;B' -gama^2];
L1=set(M<0);

%Second LMI
L2=set(N>0);

L=L1+L2;
solvesdp(L);

F=double(F);
N=double(N);

P=inv(N);
K=F*P