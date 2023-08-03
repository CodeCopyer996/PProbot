close all;

figure(1);
subplot(211);
plot(t,d(:,3),'r',t,dp(:,1),'-.b','linewidth',2);
xlabel('time(s)');ylabel('d and its estimation');
legend('d','d estiamtion');
subplot(212);
plot(t,d(:,3)-dp(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('error between d and its estimation');