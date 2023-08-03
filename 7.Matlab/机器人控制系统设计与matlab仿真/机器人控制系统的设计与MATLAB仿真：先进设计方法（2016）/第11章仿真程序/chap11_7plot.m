close all;

figure(1);
subplot(211);
plot(t,x(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle response');
subplot(212);
plot(t,x(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle speed response');

figure(2);
subplot(211);
plot(t,x(:,3),'b','linewidth',2);
xlabel('time(s)');ylabel('Cart position response');
subplot(212);
plot(t,x(:,4),'b','linewidth',2);
xlabel('time(s)');ylabel('Cart speed response');

figure(3);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('ut');