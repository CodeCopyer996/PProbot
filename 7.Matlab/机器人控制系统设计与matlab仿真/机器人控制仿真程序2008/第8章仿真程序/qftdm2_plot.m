close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input');

figure(3);
plot(t,y1(:,1),'r',t,y1(:,2),'b',t,y1(:,3),'k');
xlabel('time(s)');ylabel('Position tracking');