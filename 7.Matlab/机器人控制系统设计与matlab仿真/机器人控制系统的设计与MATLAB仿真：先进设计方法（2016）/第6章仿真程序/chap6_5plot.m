close all;

figure(1);
subplot(411);
plot(t,x(:,1),'k');
xlabel('time(s)');ylabel('x1');
subplot(412);
plot(t,x(:,2),'k');
xlabel('time(s)');ylabel('x2');
subplot(413);
plot(t,x(:,3),'k');
xlabel('time(s)');ylabel('x3');
subplot(414);
plot(t,x(:,4),'k');
xlabel('time(s)');ylabel('x4');

figure(2);
plot(t,y(:,1),'k',t,y(:,2),'k');
xlabel('time(s)');ylabel('Position tracking');
figure(3);
plot(t,ut(:,1),'-.k');
xlabel('time(s)');ylabel('Control input');
figure(4);
plot(t,gx(:,1),'-.k',t,gxp(:,1),'k');
xlabel('time(s)');ylabel('gx and its estimated value');
legend('gx','gx estimation');