close all;

figure(1);
subplot(611);
plot(t,y(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('y1');
subplot(612);
plot(t,y(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('y2');
subplot(613);
plot(t,y(:,3),'r','linewidth',2);
xlabel('time(s)');ylabel('y3');
subplot(614);
plot(t,y(:,4),'r','linewidth',2);
xlabel('time(s)');ylabel('y4');
subplot(615);
plot(t,y(:,5),'r','linewidth',2);
xlabel('time(s)');ylabel('y5');
subplot(616);
plot(t,y(:,6),'r','linewidth',2);
xlabel('time(s)');ylabel('y6');

figure(2);
plot(t,u(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input');

figure(3);
zp=y(:,7);
wp=y(:,8);
gama1=sqrt(zp./(wp+0.001));
gama=120;

plot(t,gama,'r',t,gama1,'b','linewidth',2);
xlabel('time(s)');ylabel('gama and robust performance');