close all;

figure(1);
subplot(211);
plot(t,qd(:,1),'k',t,y(:,1),'r:','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 1');
legend('ideal signal','practical signal');
subplot(212);
plot(t,qd(:,2),'k',t,y(:,3),'r:','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 2');
legend('ideal signal','practical signal');

figure(2);
subplot(211);
plot(t,qd(:,3),'k',t,y(:,2),'r:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking of link 1');
legend('ideal signal','practical signal');
subplot(212);
plot(t,qd(:,4),'k',t,y(:,4),'r:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking of link 2');
legend('ideal signal','practical signal');

figure(3);
subplot(211);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('initial control input of link 1');
subplot(212);
plot(t,ut(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('initial control input of link 2');

figure(4);
subplot(211);
plot(t,tol(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('practical control input of link 1');
subplot(212);
plot(t,tol(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('practical control input of link 2');