close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('position tracking');

figure(2);
plot(t,u,'r');
xlabel('time(s)');ylabel('control input');