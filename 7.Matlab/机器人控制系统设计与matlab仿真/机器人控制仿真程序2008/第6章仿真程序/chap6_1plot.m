close all;

figure(1);
subplot(211);
plot(t,yd(:,1),'r',t,y(:,1),'b');
xlabel('time(s)');ylabel('Position tracking');
subplot(212);
plot(t,yd(:,2),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Speed tracking');

figure(2);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input');