clear all;
close all;
global C M0 F

ts=0.02;
T=30;
TimeSet=[0:ts:T];

para=[];
options=odeset('RelTol',1e-3,'AbsTol',[1e-3 1e-3 1e-3 1e-3]);
%options=[];
x0=[0.5,0.3,0,0];
[t,xout]=ode45('chap2_3eq',TimeSet,x0,options,para);
x1=xout(:,1);
x2=xout(:,2);
x3=xout(:,3);
x4=xout(:,4);

s=C(1)*x1+C(2)*x2+C(3)*x3+C(4)*x4;

if F==1
   M0=40;
   u=-M0*sign(s);
elseif F==2
   beta=30;
   delta=0;
   for k=1:1:T/ts+1
      u(k)=-beta*(abs(x1(k))+abs(x2(k))+abs(x3(k))+abs(x4(k))+delta)*sign(s(k));
   end
end

figure(1);
plot(t,x1,'r');
xlabel('time(s)');ylabel('Cart Position');
figure(2);
plot(t,x2,'r');
xlabel('time(s)');ylabel('Pendulum Angle');
figure(3);
plot(t,s,'r');
xlabel('time(s)');ylabel('s');
figure(4);
plot(t,u,'r');
xlabel('time(s)');ylabel('u');