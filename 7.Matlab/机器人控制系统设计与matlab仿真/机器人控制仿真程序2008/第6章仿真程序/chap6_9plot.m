close all;

figure(1);
plot(t,v(:,1),'r',t,v(:,2),'b');
xlabel('time(s)');ylabel('velocity tracking');

figure(2);
plot(t,F(:,2),'r',t,F(:,1),'b');
xlabel('time(s)');ylabel('angle tracking');

figure(3);
plot(x(:,1),y(:,1),'b');
title('position tracking');
xlabel('x');ylabel('y');

figure(4);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input ur');

figure(5);
plot(t,u(:,2),'r');
xlabel('time(s)');ylabel('Control input ul');