%Grey model prediction
clear all;
close all;

ts=0.001;
n=2;

I=eye(n);
N=n+3;
c=15;
Ce=[c 1];

a=25;b=133;
A1=[0 1;0 -a];
B1=[0;b];
C1=[25 0];
D1=[0];
[A,B,C,D]=c2dm(A1,B1,C1,D1,ts,'z');

V=[1.5 -1.5];d=0.15;

x_1=[0;0];
r_2=0;r_1=0;

for k=1:1:N
time(k)=k*ts;
   
r(k)=0.5*(sin(6*pi*k*ts));
r1(k)=r(k);
r(k+1)=0.5*(sin(6*pi*(k+1)*ts)); 
dr(k)=0.5*6*pi*cos(6*pi*k*ts);
dr(k+1)=0.5*6*pi*cos(6*pi*(k+1)*ts);
   
x1(k)=x_1(1);
x2(k)=x_1(2);
      
e(k)=r(k)-x1(k);
de(k)=dr(k)-x2(k);

s(k)=Ce*[e(k);de(k)];

%Exponential velocity trending law
eq=0.5;
q=35;
ds(k)=-eq*ts*sign(s(k))-q*ts*s(k);

xr1=([r(k+1);dr(k+1)]-[r(k);dr(k)]);    %r(k+1)
u(k)=inv(Ce*B)*(Ce*xr1-Ce*(A-I)*[x1(k);x2(k)]-ds(k));
  
%Plant   
   DD=V*x_1+d;
   x=A*x_1+B*u(k)+B*DD;
   x_1=x;
   
   r_2=r_1;r_1=r(k);
end

%Grey prediction
	xx1(1)=x1(2);xx2(1)=x2(2);
	BB=[xx1(1) xx2(1) 1];

for k1=2:1:N-2
    xx1(k1)=xx1(k1-1)+x1(k1+1);
    xx2(k1)=xx2(k1-1)+x2(k1+1);
    BB=[BB;xx1(k1) xx2(k1) k1];
end

for k1=1:1:N-1
   DDD(k1)=1/B*([x1(k1+1);x2(k1+1)]-A*[x1(k1);x2(k1)])-u(k1);
end
D1(1)=DDD(2);

for k1=2:1:N-2
   D1(k1)=D1(k1-1)+DDD(k1+1);
end

ab=abs(det(BB'*BB))
V1=inv(BB'*BB)*BB'*D1';
Vp=V1'