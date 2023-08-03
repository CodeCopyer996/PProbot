%H Infinity Controller Design based on LMI for Double Inverted Pendulum
clear all;
close all;

A=[0,0,0,1.0,0,0;
   0,0,0,0,1.0,0;
   0,0,0,0,0,-1.0;
   0,-3.7864,0.2009,-4.5480,0.0037,-0.0017;
   0,41.9965,9.3378,7.6261,-0.0570,0.0349;
   0,-25.0347,-29.5778,1.0850,0.0675,-0.0543];
B1=[0;0;0;-1.1902;-55.3119;175.2019];
B2=[0;0;0;68.6019;-115.0316;-16.3660];

C=eye(6);
D=zeros(6,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q1=1.69;q2=2;q3=0.01;q4=0.3;q5=0.1;q6=0.01;
q=[q1,q2,q3,q4,q5,q6];
gama=120;

C1=[diag(q);zeros(1,6)];
rho=1;
D12=[0;0;0;0;0;0;rho];
D11=zeros(7,1);

C2=eye(6);
D21=zeros(6,1);
%%%%%%%%%%%%%%%%%%%%%%% LMI Model Design %%%%%%%%%%%%%%%%%%%%%%%
P1=sdpvar(6,6);
P2=sdpvar(1,6);
 
FAI=[A*P1+P1*A'+B2*P2+P2'*B2'+1/gama^2*B1*B1' (C1*P1+D12*P2)';C1*P1+D12*P2 -eye(7)] ;
 
%LMI description
L1=set(P1>0);
L2=set(FAI<0);
LL=L1+L2;
 
solvesdp(LL);
 
P1=double(P1);
P2=double(P2);
K=P2*inv(P1)