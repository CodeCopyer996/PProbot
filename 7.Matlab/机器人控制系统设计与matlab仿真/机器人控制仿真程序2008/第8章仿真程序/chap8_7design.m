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
%Tolerances
macheps=mach_eps;
tolsing=sqrt(macheps);
toleig=macheps^(2/3);
feasrad=1e8;

%Retrieve plant data 
[np,nu]=size(B2);
[nz,nw]=size(D11);

%LMI setup to describe
setlmis([]);  %Initializes the description of a new LMI system.

%help lmivar
%Adds a new matrix variable X to the LMI system currently
%described.  A label X can be optionally attached to this
%new variable to facilitate future reference to it.
lmivar(1,[np 1]);   %=7   X
lmivar(2,[1 np]);   %=6   Y

%First LMI
aux1=[A;C1];
aux2=[B1*B1'/(gama*gama),zeros(6,7);zeros(7,6),-eye(7)];
aux3=[eye(np) zeros(np,nz)];
aux4=[B2;D12];

%help lmiterm
%lmiterm(termID,A,B,flag)
%Adds one term to some LMI in the LMI system currently described.
%A term is either an outer factor, a constant matrix, or a
%variable term  A*X*B  or A*X'*B  where X is a matrix variable.

%  FLAG      quick way of specifying the expression  A*X*B+B'*X'*A'
%            in a DIAGONAL block.  Set  FLAG='s'  to specify it
%            with only one LMITERM command
lmiterm([1 1 1 1],aux1,aux3,'s');
lmiterm([1 1 1 0],aux2);
lmiterm([1 1 1 2],aux4,aux3,'s');

%Second LMI
lmiterm([2 1 1 1],-1,1);

%>help getlmis:
%Returns the internal representation LMISYS of an LMI
%system once this LMI system has been fully described
%with LMIVAR and LMITERM.
LMIs=getlmis;   %(3.16)

%%%%%%%%%%%%%%%%%%%   Solution of LMI   %%%%%%%%%%%%%%%%%%%%%%
%>help feasp:
%Solves the feasibility problem defined by the system LMIS
%of LMI constraints.  When the problem is feasible, the output
%XFEAS is a feasible value of the vector of (scalar) decision
%variables.

%[tmin,xfeas] = feasp(lmis,options,target)
%Output:
%TMIN      value of t upon termination.  The LMI system is
%          feasible   iff.  TMIN <= 0                %iff.(=if and only if)
%XFEAS     corresponding minimizer.  If TMIN <= 0, XFEAS is
%          a feasible vector for the set of LMI constraints.
%          Use DEC2MAT to get the matrix variable values from
%          XFEAS.
[tmin,feasolution]=feasp(LMIs);

if tmin>0
   X=[];Y=[];
else   
% Solving P1,P2
   P1=dec2mat(LMIs,feasolution,1);   %P1:
   P2=dec2mat(LMIs,feasolution,2);   %P2
end

K=P2*inv(P1)