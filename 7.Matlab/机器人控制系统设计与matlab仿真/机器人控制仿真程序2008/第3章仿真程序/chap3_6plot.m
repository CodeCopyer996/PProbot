close all;

figure(1);
plot(t,x(:,1),'r',t,x(:,2),'b');
xlabel('time(s)');ylabel('position tracking for link');

figure(2);
plot(t,x(:,1)-x(:,2),'r');
xlabel('time(s)');ylabel('position tracking error for link');

figure(3);
plot(t,tol(:,1),'r');
xlabel('time(s)');ylabel('contro input of link');

figure(4);
plot(t,C(:,1),'r',t,C(:,2),'b');
xlabel('time(s)');ylabel('C and Cnn');