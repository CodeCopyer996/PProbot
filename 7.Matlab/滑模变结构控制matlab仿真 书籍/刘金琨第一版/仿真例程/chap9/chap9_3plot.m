close all;

figure(1);
plot(t,x1(:,1),'r',t,x1(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,x1(:,1)-x1(:,2),'r');
xlabel('time(s)');ylabel('Position tracking error');

figure(3);
plot(t,u,'r');
xlabel('time(s)');ylabel('Control input');

figure(4);
plot(t,du,'r');
xlabel('time(s)');ylabel('Dynamic control input');