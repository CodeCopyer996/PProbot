close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('position tracking');

figure(2);
subplot(411);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('tol');
subplot(412);
plot(t,u(:,2),'b');
xlabel('time(s)');ylabel('tol0');
subplot(413);
plot(t,u(:,3),'g');
xlabel('time(s)');ylabel('Yup');
subplot(414);
plot(t,u(:,4),'k');
xlabel('time(s)');ylabel('ur');