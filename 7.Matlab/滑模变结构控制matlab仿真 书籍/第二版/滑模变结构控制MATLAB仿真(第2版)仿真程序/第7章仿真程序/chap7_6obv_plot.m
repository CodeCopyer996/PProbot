close all;

figure(1);
subplot(211);
plot(t,y(:,3),'r',t,y1(:,1),'k:','linewidth',2);
xlabel('time(s)');ylabel('x1 and its estimate');
subplot(212);
plot(t,y(:,4),'r',t,y1(:,2),'k:','linewidth',2);
xlabel('time(s)');ylabel('x2 and its estimate');