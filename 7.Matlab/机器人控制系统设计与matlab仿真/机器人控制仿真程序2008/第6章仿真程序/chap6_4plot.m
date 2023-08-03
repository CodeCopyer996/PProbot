close all;

figure(1);
plot(t,x(:,1),'r',t,x(:,6),'b');
xlabel('time(s)');ylabel('position tracking of link');

figure(2);
plot(t,tol,'r');
xlabel('time(s)');ylabel('Control input');