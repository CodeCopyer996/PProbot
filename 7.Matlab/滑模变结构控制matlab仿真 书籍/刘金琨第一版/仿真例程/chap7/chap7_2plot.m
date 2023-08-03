close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,du(:,1),'r');
xlabel('time(s)');ylabel('Derivative of Control input');

figure(3);
plot(t,u,'r');
xlabel('time(s)');ylabel('Control input');