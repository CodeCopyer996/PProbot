%Discrete Sliding Mode Control with grey model prediction
clear all;
close all;

ts=0.001;
n=2;
N1=1500;

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
Vp=[1.5000 -1.5000 0.1500];

x_1=[0;0];
r_2=0;r_1=0;

for k=1:1:N1
   time(k)=k*ts;
   
   r(k)=0.5*(sin(6*pi*k*ts));
   r1(k)=r(k);
   r(k+1)=0.5*(sin(6*pi*(k+1)*ts)); 
   dr(k)=0.5*6*pi*cos(6*pi*k*ts);
   dr(k+1)=0.5*6*pi*cos(6*pi*(k+1)*ts);
   
   x1(k)=x_1(1);
   x2(k)=x_1(2);
      
%Control law
M=1;
if M==1
   uc(k)=-(Vp(1)*x_1(1)+Vp(2)*x_1(2)+Vp(3));   %Grey Compensation
elseif M==2
   uc(k)=0;   %No Grey Compensation
end
e(k)=r(k)-x1(k);
de(k)=dr(k)-x2(k);

s(k)=Ce*[e(k);de(k)];

%Exponential velocity trending law
eq=0.5;
q=35;
ds(k)=-eq*ts*sign(s(k))-q*ts*s(k);

xr1=([r(k+1);dr(k+1)]-[r(k);dr(k)]);    %r(k+1)
us(k)=inv(Ce*B)*(Ce*xr1-Ce*(A-I)*[x1(k);x2(k)]-ds(k));

u(k)=us(k)+uc(k);
  
%Plant   
   DD=V*x_1+d;
   x=A*x_1+B*u(k)+B*DD;
   x_1=x;
   r_2=r_1;r_1=r(k);
end
figure(1);
plot(time,r1,'r',time,x1,'b');
xlabel('time(s)');ylabel('position tracking');
figure(2);
plot(time,u);
xlabel('time(s)');ylabel('control input');
figure(3);
plot(e,de,'r',e,-c*e,'b');
xlabel('e');ylabel('de');
figure(4);
plot(time,s);
xlabel('time(s)');ylabel('s');