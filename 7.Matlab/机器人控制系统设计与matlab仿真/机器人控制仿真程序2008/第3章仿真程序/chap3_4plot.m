close all;

figure(1);
plot(t,x(:,1),'r',t,x(:,2),'b');
xlabel('time(s)');ylabel('position tracking');

figure(2);
plot(t,tol1(:,1),'r');
xlabel('time(s)');ylabel('tol1');

figure(3);
plot(t,tol2(:,1),'r');
xlabel('time(s)');ylabel('tol2');

figure(4);
plot(t,tol(:,1),'r');
xlabel('time(s)');ylabel('tol');

figure(5);
plot(t,f(:,1),'r',t,f(:,2),'b');
xlabel('time(s)');ylabel('f and fn');