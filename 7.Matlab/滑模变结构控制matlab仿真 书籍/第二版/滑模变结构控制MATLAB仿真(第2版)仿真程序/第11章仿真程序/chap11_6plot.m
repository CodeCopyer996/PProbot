close all;

figure(1);
subplot(211);
plot(t,qd(:,1),'k',t,q(:,1),'r:','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 1');
legend('ideal signal','tracking signal');
subplot(212);
plot(t,qd(:,2),'k',t,q(:,2),'r:','linewidth',2);
xlabel('time(s)');ylabel('speed tracking of link 1');
legend('ideal signal','tracking signal');

figure(2);
subplot(211);
plot(t,qd(:,4),'k',t,q(:,3),'r:','linewidth',2);
xlabel('time(s)');ylabel('position tracking of link 2');
legend('ideal signal','tracking signal');
subplot(212);
plot(t,qd(:,5),'k',t,q(:,4),'r:','linewidth',2);
xlabel('time(s)');ylabel('speed tracking of link 2');
legend('ideal signal','tracking signal');

figure(3);
subplot(211);
plot(t,p(:,1)/6.7,'r','linewidth',2);
xlabel('time(s)');ylabel('alfa estimate precison');
subplot(212);
plot(t,p(:,2)/3.4,'r','linewidth',2);
xlabel('time(s)');ylabel('beta estimate precison');

figure(4);
subplot(211);
plot(t,p(:,3)/3.0,'r','linewidth',2);
xlabel('time(s)');ylabel('epc estimate precison');
subplot(212);
plot(t,p(:,4)/3,'r','linewidth',2);
xlabel('time(s)');ylabel('eta estimation');