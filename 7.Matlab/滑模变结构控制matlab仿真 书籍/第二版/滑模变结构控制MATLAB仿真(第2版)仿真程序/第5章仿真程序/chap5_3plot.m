close all;

figure(1);
subplot(411);
plot(t,x(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('x1');
subplot(412);
plot(t,x(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('x2');
subplot(413);
plot(t,x(:,3),'r','linewidth',2);
xlabel('time(s)');ylabel('x3');
subplot(414);
plot(t,x(:,4),'r','linewidth',2);
xlabel('time(s)');ylabel('x4');

figure(2);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('ut');