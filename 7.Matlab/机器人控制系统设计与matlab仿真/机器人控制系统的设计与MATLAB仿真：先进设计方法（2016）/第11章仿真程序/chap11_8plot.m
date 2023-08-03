close all;

figure(1);
subplot(211);
plot(t,x(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('x1 response');
subplot(212);
plot(t,x(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('x2 response');

figure(2);
subplot(211);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('ut');
subplot(212);
plot(t,du(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('du');