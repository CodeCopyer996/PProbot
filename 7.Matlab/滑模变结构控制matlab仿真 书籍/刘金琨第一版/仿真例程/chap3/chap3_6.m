%Discrete Reaching Law VSS Control based on Kalman Filter
clear all;
close all;

a=25;b=133;

ts=0.001;
A1=[0,1;0,-a];
B1=[0;b];
C1=[1,0];
D1=0;
[A,B,C,D]=c2dm(A1,B1,C1,D1,ts,'z');

x=[-0.5;-0.5];
r_1=0;r_2=0;

Q=10;           %Covariances of w
Rm=10;          %Covariances of v
P=B*Q*B';       %Initial error covariance

for k=1:1:2000
   time(k)=k*ts;
   
   r(k)=0.5*sin(1*2*pi*k*ts);
   c=30;eq=150;q=300;
   Ce=[c,1];
   
%Using Waitui method   
   dr(k)=(r(k)-r_1)/ts;
   dr_1=(r_1-r_2)/ts;
   r1(k)=2*r(k)-r_1;
   dr1(k)=2*dr(k)-dr_1;
  
   R=[r(k);dr(k)];
   R1=[r1(k);dr1(k)];
   
   E=R-x;
   e(k)=E(1);
   de(k)=E(2);
   
   s(k)=Ce*E;
   ds(k)=-eq*ts*sign(s(k))-q*ts*s(k);
   
   u(k)=inv(Ce*B)*(Ce*R1-Ce*A*x-s(k)-ds(k));
	wn(k)=rands(1);       %Process noise on u
	u(k)=u(k)+wn(k);
   
   x=A*x+B*u(k);
   v(k)=0.015*rands(1);  %Measurement noise on y
   yv(k)=C*x+v(k);

 M=1;
 if M==1        %Kalman Filter
    Mn=P*C'/(C*P*C'+Rm);
    P=A*P*A'+B*Q*B'; 
    P=(eye(2)-Mn*C)*P;
    x=A*x+Mn*(yv(k)-C*A*x);
    ye(k)=C*x;
 elseif M==2    %No Filter
	 ye(k)=yv(k); 
    x(1)=ye(k);
 end
 
 
%Update Parameters
r_2=r_1;
r_1=r(k);
end

figure(1);
subplot(211);
plot(time,yv,'b');
xlabel('Time(s)');ylabel('yv');
subplot(212);
plot(time,ye,'r');
xlabel('Time(s)');ylabel('ye');

figure(2);
plot(time,r,'r',time,ye,'b');
xlabel('Time(second)');ylabel('position tracking');
figure(3);
plot(time,s,'r');
xlabel('Time(second)');ylabel('Switch function s');
figure(4);
plot(e,de,'r',e,-c*e,'b');
xlabel('e');ylabel('de');
figure(5);
plot(time,u,'r');
xlabel('Time(second)');ylabel('u');