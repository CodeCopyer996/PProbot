close all;

figure(1);
plot(t,r(:,1),'r',t,y(:,1),'b');
xlabel('time(s)');ylabel('position tracking of link 1');
figure(2);
plot(t,r(:,2),'r',t,y(:,3),'b');
xlabel('time(s)');ylabel('position tracking of link 2');

figure(3);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('initial control of link 1');
figure(4);
plot(t,u(:,2),'r');
xlabel('time(s)');ylabel('initial control of link 2');

figure(5);
plot(t,tol(:,1),'r');
xlabel('time(s)');ylabel('practical control of link 1');
figure(6);
plot(t,tol(:,2),'r');
xlabel('time(s)');ylabel('practical control of link 2');