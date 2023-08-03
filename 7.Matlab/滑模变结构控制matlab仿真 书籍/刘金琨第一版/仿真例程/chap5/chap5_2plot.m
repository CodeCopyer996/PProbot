close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time');ylabel('y and ym');

figure(2);
plot(t,y(:,1)-y(:,2),'r');
xlabel('time');ylabel('identification error');