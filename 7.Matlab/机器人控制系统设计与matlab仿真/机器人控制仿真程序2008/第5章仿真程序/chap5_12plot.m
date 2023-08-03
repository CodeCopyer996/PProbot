close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,ut(:,1),'r');
xlabel('time(s)');ylabel('Control input');

figure(3);
plot(t,e(:,1),'r');
xlabel('time(s)');ylabel('Position tracking error');