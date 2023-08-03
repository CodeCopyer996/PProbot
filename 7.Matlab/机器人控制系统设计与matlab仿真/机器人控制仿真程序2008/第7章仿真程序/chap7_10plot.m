close all;
figure(1);
subplot(211);
plot(t,y1(:,1),'r',t,y1(:,2),'b');
xlabel('time(s)');ylabel('position tracking of link 1');
subplot(212);
plot(t,y2(:,1),'r',t,y2(:,2),'b');
xlabel('time(s)');ylabel('position tracking of link 2');

figure(3);
subplot(211);
plot(t,tol(:,1),'r');
xlabel('time(s)');ylabel('control input of link 1');
subplot(212);
plot(t,tol(:,2),'r');
xlabel('time(s)');ylabel('control input of link 2');