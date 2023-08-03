close all;

figure(1);
subplot(611);
plot(t,y(:,1),'r');
subplot(612);
plot(t,y(:,2),'r');
subplot(613);
plot(t,y(:,3),'r');
subplot(614);
plot(t,y(:,4),'r');
subplot(615);
plot(t,y(:,5),'r');
subplot(616);
plot(t,y(:,6),'r');
xlabel('time(s)');ylabel('y6');

figure(2);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input');

figure(3);
zp=y(:,7);
wp=y(:,8);
gama1=sqrt(zp./(wp+0.001));
gama=120;

plot(t,gama,'r',t,gama1,'b');
xlabel('time(s)');ylabel('gama and robust performance');