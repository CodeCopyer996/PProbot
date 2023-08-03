close all;

figure(1);
plot(t,r(:,1),'r',t,x(:,1),'b');
xlabel('time(s)');ylabel('Position tracking of x11');
figure(2);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('control 1');

figure(3);
plot(t,r(:,2),'r',t,x(:,4),'b');
xlabel('time(s)');ylabel('Position tracking of x21');
figure(4);
plot(t,u(:,2),'r');
xlabel('time(s)');ylabel('control 2');

figure(5);
plot(t,r(:,3),'r',t,x(:,7),'b');
xlabel('time(s)');ylabel('Position tracking of x31');
figure(6);
plot(t,u(:,3),'r');
xlabel('time(s)');ylabel('control 3');