close all;

figure(1);
plot(t,sin(t),t,x(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('angle tracking');
legend('x1','x1d');

figure(2);
subplot(411);
plot(t,xp(:,1),'b',t,x(:,1),'r:','linewidth',2);
xlabel('t');ylabel('x_1');
legend('x1','x1p');
subplot(412);
plot(t,xp(:,2),'b',t,x(:,2),'r:','linewidth',2);
xlabel('t');ylabel('x_2');
legend('x2','x2p');
subplot(413);
plot(t,xp(:,3),'b',t,x(:,3),'r:','linewidth',2);
xlabel('t');ylabel('x_3');
legend('x3','x3p');
subplot(414);
plot(t,xp(:,4),'b',t,x(:,4),'r:','linewidth',2);
xlabel('t');ylabel('x_4');
legend('x4','x4p');

figure(3);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('ut');