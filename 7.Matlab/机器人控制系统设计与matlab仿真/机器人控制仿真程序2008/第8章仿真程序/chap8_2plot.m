close all;
figure(1);
plot(t,x(:,1),'r',t,x(:,2),'b');
xlabel('time(s)');ylabel('position tracking');
figure(2);
plot(t,tol(:,1),'r');
xlabel('time(s)');ylabel('tol');