close all;

figure(1);
subplot(211);
plot(t,yd(:,1),'r',t,y(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
subplot(212);
plot(t,cos(t),'r',t,y(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');

figure(2);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input');

figure(3);
subplot(211);
plot(t,kb1,'-.r',t,-kb1,'-.k',t,z1(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('z1');
subplot(212);
plot(t,x1_min,'-.r',t,x1_max,'-.k',t,y(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('x1');