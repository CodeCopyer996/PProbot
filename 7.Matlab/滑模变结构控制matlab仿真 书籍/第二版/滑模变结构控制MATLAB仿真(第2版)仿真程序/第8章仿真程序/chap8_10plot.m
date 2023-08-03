close all;

figure(1);
subplot(211);
plot(t,yd1(:,1),'k',t,y(:,1),'r:','linewidth',2);
xlabel('time(s)');ylabel('Position tracking of link1');
legend('ideal position','position tracking');
subplot(212);
plot(t,yd2(:,1),'r',t,y(:,3),'r:','linewidth',2);
xlabel('time(s)');ylabel('Position tracking of link2');
legend('ideal position','position tracking');

figure(2);
subplot(211);
plot(t,yd1(:,2),'k',t,y(:,2),'r:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking of link1');
legend('ideal speed','speed tracking');
subplot(212);
plot(t,yd2(:,2),'r',t,y(:,4),'r:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking of link2');
legend('ideal speed','speed tracking');

figure(3);
subplot(211);
plot(t,y(:,5),'k',t,u(:,3),'r:','linewidth',2);
xlabel('time(s)');ylabel('F and Fc of link1');
legend('F','F compensation');
subplot(212);
plot(t,y(:,6),'k',t,u(:,4),'r:','linewidth',2);
xlabel('time(s)');ylabel('F and Fc of link2');
legend('F','F compensation');

figure(4);
subplot(211);
plot(t,u(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input of Link1');
subplot(212);
plot(t,u(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input of Link2');