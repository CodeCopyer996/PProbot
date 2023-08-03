close all;

figure(1);
subplot(211);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');
subplot(212);
plot(t,y(:,1)-y(:,2),'r');
xlabel('time(s)');ylabel('Position tracking error');

figure(2);
plot(t,ut(:,1),'r');
xlabel('time(s)');ylabel('Control input');

figure(3);
plot(t,f(:,3),'r',t,f(:,4),'b');
xlabel('time(s)');ylabel('f and fp');