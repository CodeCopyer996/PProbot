close all;

figure(1);
plot(t,d(:,1),'r');
xlabel('time(s)');ylabel('Disturbance');

figure(2);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(3);
plot(t,y(:,1)-y(:,2),'r');
xlabel('time(s)');ylabel('Position tracking error');

figure(4);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input');

figure(5);
plot(t,miu(:,1),'r');
xlabel('time(s)');ylabel('Membership function degree');