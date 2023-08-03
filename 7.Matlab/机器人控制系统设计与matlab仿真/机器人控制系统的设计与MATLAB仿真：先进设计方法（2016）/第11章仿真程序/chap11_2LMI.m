clear all;
close all;

J=1/133;
b=25/133;

A=[0 1;
   0 -b/J];
B=[0 1/J]';

K=sdpvar(1,2);

M=sdpvar(3,3);
F=sdpvar(1,2);

P=sdpvar(2,2,'symmetric');
N=sdpvar(2,2,'symmetric');
alfa=10;

%First LMI
L1=set((alfa*N+A*N+B*F+N*A'+F'*B')<0);
%Second LMI
L2=set(N>0);

L=L1+L2;
solvesdp(L);

F=double(F);
N=double(N);

P=inv(N)
K=F*P