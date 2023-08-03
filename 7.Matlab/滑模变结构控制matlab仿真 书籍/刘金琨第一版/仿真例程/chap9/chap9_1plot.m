close all;

figure(1);
plot(t,r(:,1),'r',t,x(:,1),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('control 1');