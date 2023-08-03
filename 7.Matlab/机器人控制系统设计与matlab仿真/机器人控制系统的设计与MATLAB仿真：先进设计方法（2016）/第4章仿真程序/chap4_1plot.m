close all;
figure(1);
plot(t,y(:,1),'r',t,y(:,2),'-.b','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
legend('ideal x1','practical x1');

figure(2);
plot(t,ut,'r','linewidth',2);
xlabel('time(s)');ylabel('Control input');