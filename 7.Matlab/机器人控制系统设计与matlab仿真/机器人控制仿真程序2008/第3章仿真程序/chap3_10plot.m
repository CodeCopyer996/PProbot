close all;

figure(1);
plot(t,x(:,1),'r',t,x(:,2),'b');
xlabel('time(s)');ylabel('position tracking');

figure(2);
plot(t,w,'r');
xlabel('time(s)');ylabel('w');

figure(3);
plot(t,u,'r');
xlabel('time(s)');ylabel('u');

figure(4);
plot(t,tol,'r');
xlabel('time(s)');ylabel('tol');

figure(5);
plot(t,d(:,1),'r',t,d(:,2),'b');
xlabel('time(s)');ylabel('d and dp');