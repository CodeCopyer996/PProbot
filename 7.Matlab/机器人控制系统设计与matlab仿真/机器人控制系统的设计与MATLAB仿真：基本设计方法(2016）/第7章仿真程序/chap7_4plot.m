close all;
figure(1);
subplot(211);
plot(t,thd(:,1),'r',t,x(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('angle tracking of first link');
subplot(212);
plot(t,thd(:,3),'r',t,x(:,3),'b','linewidth',2);
xlabel('time(s)');ylabel('angle tracking of second link');

figure(2);
subplot(211);
plot(t,thd(:,2),'r',t,x(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('angle speed tracking of first link');
subplot(212);
plot(t,thd(:,4),'r',t,x(:,4),'b','linewidth',2);
xlabel('time(s)');ylabel('angle speed tracking of second link');

figure(3);
subplot(211);
plot(t,d(:,1),'r',t,dp(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('dt1 and its estimation');
subplot(212);
plot(t,d(:,2),'r',t,dp(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('dt2 and its estimation');

figure(4);
subplot(211);
plot(t(:,1),tol(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('tol1');
subplot(212);
plot(t(:,1),tol(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('tol2');