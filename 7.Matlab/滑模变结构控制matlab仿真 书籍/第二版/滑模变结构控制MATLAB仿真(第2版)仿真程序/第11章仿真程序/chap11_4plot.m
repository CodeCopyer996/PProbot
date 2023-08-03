close all;

figure(1);
subplot(211);
plot(t,qd(:,1),'k',t,y(:,1),'r:','linewidth',2);
xlabel('time(s)');ylabel('position tracking');
subplot(212);
plot(t,qd(:,2),'k',t,y(:,2),'r:','linewidth',2);
xlabel('time(s)');ylabel('speed tracking');

figure(2);
subplot(211);
plot(t,ut,'r','linewidth',2);
xlabel('time(s)');ylabel('initial control input');
subplot(212);
plot(t,tol,'r','linewidth',2);
xlabel('time(s)');ylabel('filtered control input');