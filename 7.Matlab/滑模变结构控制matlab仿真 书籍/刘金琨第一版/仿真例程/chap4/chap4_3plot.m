close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,E(:,1),'r',t,E(:,2),'b');
xlabel('time(s)');ylabel('E and estimated K');

figure(3);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input');