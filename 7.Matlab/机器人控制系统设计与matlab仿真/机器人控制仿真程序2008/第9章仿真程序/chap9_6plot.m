close all;

figure(1);
subplot(211);
plot(t,xp(:,1),'r',t,xp(:,3),'b');
xlabel('time');ylabel('x1 and its observer value');
subplot(212);
plot(t,xp(:,2),'r',t,xp(:,4),'b');
xlabel('time');ylabel('x2 and its observer value');

figure(2);
subplot(211);
plot(t,xp(:,1)-xp(:,3),'r');
xlabel('time');ylabel('error betweem x1 and x2p');
subplot(212);
plot(t,xp(:,2)-xp(:,4),'r');
xlabel('time');ylabel('error betweem x2 and x2p');