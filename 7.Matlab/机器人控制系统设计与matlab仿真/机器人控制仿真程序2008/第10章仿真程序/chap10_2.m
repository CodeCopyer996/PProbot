%TSP Solving by Hopfield Neural Network
function TSP_hopfield()
clear all;
close all;

A=1.5;
D=1;
u0=0.02;
Step=0.01;

S=2;
if S==1
	N=4;
	cityfile = fopen( 'e:\ljkmb\4.txt', 'rt' );
elseif S==2
	N=8;
	cityfile = fopen( 'e:\ljkmb\8.txt', 'rt' );
elseif S==3
	N=16;
	cityfile = fopen( 'e:\ljkmb\16.txt', 'rt' );
end
citys = fscanf( cityfile, '%f %f',[ 2,inf] )
fclose(cityfile);
Initial_Length=Initial_RouteLength(citys);

DistanceCity=dist(citys',citys);

u=2*rand(N,N)-1;
U=0.5*u0*log(N-1)+u;
V=(1+tanh(U/u0))/2;

for k=1:1:4000
times(k)=k;

	 dU=DeltaU(V,DistanceCity,A,D);
    U=U+dU*Step;
    
    V=(1+tanh(U/u0))/2;
    E=Energy(V,DistanceCity,A,D);
    Ep(k)=E;
	 [V1,CheckR]=RouteCheck(V); 
end

if(CheckR==0)
   Final_E=Energy(V1,DistanceCity,A,D);
   Final_Length=Final_RouteLength(V1,citys);
	disp('迭代次数');k
	disp('寻优路径矩阵:');V1
    disp('最优能量函数:');Final_E
  	disp('初始路程:');Initial_Length
  	disp('最短路程:');Final_Length
     
	PlotR(V1,citys);
else
	disp('寻优路径无效');
end

figure(2);
plot(times,Ep,'r');
title('Energy Function Change');
xlabel('k');ylabel('E');

%%%%%%%能量函数
function E=Energy(V,d,A,D)
[n,n]=size(V);
t1=sumsqr(sum(V,2)-1);
t2=sumsqr(sum(V,1)-1);
PermitV=V(:,2:n);
PermitV=[PermitV,V(:,1)];
temp=d*PermitV;
t3=sum(sum(V.*temp));
E=0.5*(A*t1+A*t2+D*t3);

%%%%%%%计算du
function du=DeltaU(V,d,A,D)
[n,n]=size(V);
t1=repmat(sum(V,2)-1,1,n);
t2=repmat(sum(V,1)-1,n,1);
PermitV=V(:,2:n);
PermitV=[PermitV, V(:,1)];
t3=d*PermitV;
du=-1*(A*t1+A*t2+D*t3);

%%%%%%标准化路径，并检查路径合法性
function [V1,CheckR]=RouteCheck(V)
[rows,cols]=size(V);
V1=zeros(rows,cols);
[XC,Order]=max(V);
for j=1:cols
    V1(Order(j),j)=1;
end
C=sum(V1);
R=sum(V1');
CheckR=sumsqr(C-R);

%%%%%%%%计算初始总路程
function L0=Initial_RouteLength(citys)
[r,c]=size(citys);
L0=0;
for i=2:c
   L0=L0+dist(citys(:,i-1)',citys(:,i));
end

%%%%%%%计算最终总路程
function L=Final_RouteLength(V,citys)
[xxx,order]=max(V);
New=citys(:,order);
New=[New New(:,1)];
[rows,cs]=size(New);

L=0;
for i=2:cs
    L=L+dist(New(:,i-1)',New(:,i));
end

function PlotR(V,citys)
figure;

citys=[citys citys(:,1)];

[xxx,order]=max(V);
New=citys(:,order);
New=[New New(:,1)];

subplot(1,2,1);
plot( citys(1,1), citys(2,1),'*' );   %First city
hold on;
plot( citys(1,2), citys(2,2),'+' );   %Second city
hold on;
plot( citys(1,:), citys(2,:),'o-' ), xlabel('X axis'), ylabel('Y axis'), title('Original Route');
axis([0,1,0,1]);

subplot(1,2,2);
plot( New(1,1), New(2,1),'*' );   %First city
hold on;
plot( New(1,2), New(2,2),'+' );   %Second city
hold on;
plot(New(1,:),New(2,:),'o-');
title('TSP solution');
xlabel('X axis');ylabel('Y axis');
axis([0,1,0,1]);

axis on