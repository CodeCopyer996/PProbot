close all;

figure(1);
plot(t,y(:,1),'r');
xlabel('time(s)');ylabel('state response');

figure(2);
plot(t,du,'r');
xlabel('time(s)');ylabel('derivative of control input');

figure(3);
plot(t,u,'r');
xlabel('time(s)');ylabel('control input');