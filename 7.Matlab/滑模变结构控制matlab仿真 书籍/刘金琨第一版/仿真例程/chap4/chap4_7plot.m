close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input');

figure(3);
plot(t,f(:,1),'r',t,f(:,2),'b');
xlabel('time(s)');ylabel('f and estiamted f');

figure(4);
plot(t,g(:,1),'r',t,g(:,2),'b');
xlabel('time(s)');ylabel('g and estimated g');