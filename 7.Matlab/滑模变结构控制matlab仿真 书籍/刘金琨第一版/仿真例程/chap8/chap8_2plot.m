close all;
c=20;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('State response');

figure(2);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('control input');

figure(3);
plot(y(:,1),y(:,2),'r',y(:,1),-c*y(:,1),'b');
xlabel('x1');ylabel('x2');

figure(4);
plot(t,y(:,4),'r',t,ef(:,1),'b');
xlabel('time(s)');ylabel('f and ef');