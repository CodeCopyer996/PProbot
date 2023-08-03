close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('position tracking');

figure(2);
plot(t,u,'r');
xlabel('time(s)');ylabel('initial control input');

figure(3);
plot(t,tol,'r');
xlabel('time(s)');ylabel('practical control input');