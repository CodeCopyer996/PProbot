clear all;
close all;

g=9.8;M=1.0;m=0.1;L=0.5;

I=1/12*m*L^2;  
l=1/2*L;
t1=m*(M+m)*g*l/[(M+m)*I+M*m*l^2];
t2=-m^2*g*l^2/[(m+M)*I+M*m*l^2];
t3=-m*l/[(M+m)*I+M*m*l^2];
t4=(I+m*l^2)/[(m+M)*I+M*m*l^2];

A=[0,1,0,0;
   t1,0,0,0;
   0,0,0,1;
   t2,0,0,0];
B=[0;t3;0;t4];

K=sdpvar(1,4);
F=sdpvar(1,4);
P=sdpvar(4,4,'symmetric');
N=sdpvar(4,4,'symmetric');

umax=3.0;
alfa=1.0;w_bar=1.0;

%First LMI
x0=[0.1 0 0.1 0]';
L1=set((alfa*N+A*N+B*F+N*A'+F'*B')<0);

%Second LMI
k0=umax^2/w_bar;
M1=[k0*N F';F 1]; 
L2=set(M1>0);

%Third LMI
L3=set(N>0);

%Fourth LMI
M2=[w_bar x0';x0 N];
L4=set(M2>0);

L=L1+L2+L3+L4;
solvesdp(L);

F=double(F);
N=double(N);

P=inv(N)
K=F*P