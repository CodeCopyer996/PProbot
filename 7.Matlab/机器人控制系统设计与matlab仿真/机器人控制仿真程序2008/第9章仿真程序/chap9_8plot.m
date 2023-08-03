close all;

figure(1);
subplot(211);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time');ylabel('Position tracking');
subplot(212);
plot(t,cos(t),'r',t,y(:,3),'b');
xlabel('time');ylabel('Speed tracking');

figure(2);
subplot(211);
plot(t,y(:,2),'r',t,y(:,4),'b');
xlabel('time');ylabel('x1 and its observer value');
subplot(212);
plot(t,y(:,3),'r',t,y(:,5),'b');
xlabel('time');ylabel('x2 and its observer value');

figure(3);
subplot(211);
plot(t,y(:,2)-y(:,4),'r');
xlabel('time');ylabel('error betweem x1 and x2p');
subplot(212);
plot(t,y(:,3)-y(:,5),'r');
xlabel('time');ylabel('error betweem x2 and x2p');