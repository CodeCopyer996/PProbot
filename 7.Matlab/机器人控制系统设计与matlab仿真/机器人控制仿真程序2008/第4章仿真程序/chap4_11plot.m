close all;
figure(1);
plot(t,x(:,1),'r',t,x(:,2),'b');
xlabel('time(s)');ylabel('position tracking of link 1');

figure(2);
plot(t,w(:,1),'r');
xlabel('time(s)');ylabel('w');

figure(3);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('u');

figure(4);
plot(t,tol(:,1),'r');
xlabel('time(s)');ylabel('tol');

figure(5);
plot(t,d(:,1),'r',t,d(:,2),'b');
xlabel('time(s)');ylabel('d and dp');