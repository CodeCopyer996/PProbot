clear all;
close all;
global S A F c alfa beta

xk=[0,0];

ts=0.001;
T=1;
TimeSet=[0:ts:T];

[t,y]=ode45('chap2_1eq',TimeSet,xk,[],[]);
x1=y(:,1);
x2=y(:,2);

if S==1
   rin=1.0;
   drin=0;
elseif S==2
   rin=A*sin(F*2*pi*t);
   drin=A*F*2*pi*cos(F*2*pi*t);
end

e1=rin-x1;
e2=drin-x2;
s=c*e1+e2;

for k=1:1:T/ts+1
   u(k)=(alfa*abs(e1(k))+beta*abs(e2(k)))*sign(s(k));
end

figure(1);
plot(t,rin,'r',t,y(:,1),'b');
xlabel('time(s)');ylabel('Position tracking');
figure(2);
plot(t,u,'r');
xlabel('time(s)');ylabel('u');
figure(3);
plot(e1,e2,'r',e1,-c*e1,'b');
xlabel('time(s)');ylabel('Phase trajectory');