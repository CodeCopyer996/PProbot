close all;
figure(1);
subplot(211);
plot(t,q1(:,1),'r',t,q1(:,2),'-.b','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 1');
legend('ideal q1','practical q1');
subplot(212);
plot(t,q2(:,1),'r',t,q2(:,2),'-.b','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 2');
legend('ideal q2','practical q2');

figure(2);
subplot(211);
plot(t,tol(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('control input 1');
subplot(212);
plot(t,tol(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('control input 2');