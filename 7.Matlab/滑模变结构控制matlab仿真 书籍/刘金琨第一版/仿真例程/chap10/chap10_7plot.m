close all;

figure(1);
plot(t,x(:,1),'r',t,x(:,2),'b');
xlabel('time(s)');ylabel('state response');

figure(2);
plot(t,u,'r');
xlabel('time(s)');ylabel('control input');

figure(3);
c=5;
plot(x(:,1),x(:,2),'r',x(:,1),-c*x(:,1),'b');
xlabel('x1');ylabel('x2');