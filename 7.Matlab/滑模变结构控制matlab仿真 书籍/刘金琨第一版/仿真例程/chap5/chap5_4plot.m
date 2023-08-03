close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time');ylabel('position tracking');

figure(2);
plot(t,u(:,1),'r');
xlabel('time');ylabel('control input');

figure(3);
cc=25;
plot(e,de,'b',e,-cc*e,'r');
xlabel('x1');ylabel('x2');