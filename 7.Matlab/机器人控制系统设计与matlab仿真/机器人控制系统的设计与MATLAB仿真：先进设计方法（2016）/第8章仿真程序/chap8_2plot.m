close all;
figure(1);
subplot(211);
plot(t,v(:,1),'r',t,v(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('velocity tracking');
subplot(212);
plot(t,F(:,2),'r',t,F(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('angle tracking');
figure(2);
plot(x(:,1),y(:,1),'b','linewidth',2);
title('position tracking');
xlabel('x');ylabel('y');
figure(3);
subplot(211);
plot(t,u(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input ur');
subplot(212);
plot(t,u(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input ul');