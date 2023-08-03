%Sliding Mode Observer
clear all;
close all;

xk=[0,2];

ts=0.001;
T=10;
TimeSet=[0:ts:T];
para=[];
[t,y]=ode45('chap8_1eq',TimeSet,xk,[],para);

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position');