close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('position tracking');

figure(2);
plot(t,y(:,1)-y(:,2),'r');
xlabel('time(s)');ylabel('error');

figure(3);
plot(t,u,'r');
xlabel('time(s)');ylabel('control input');

figure(4);
plot(t,s,'r');
xlabel('time(s)');ylabel('sliding surface');