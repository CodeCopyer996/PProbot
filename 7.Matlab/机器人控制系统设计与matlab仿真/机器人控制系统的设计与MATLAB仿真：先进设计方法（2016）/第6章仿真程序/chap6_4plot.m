close all;
time=t*0.+1;

figure(1);
subplot(211);
plot(t,y(:,1),'r : ',t,y(:,2),'k','linewidth',2);
xlabel('Time(sec)');ylabel('Angle tracking');
subplot(212);
plot(t,y(:,2)-y(:,1),'k','linewidth',2);
xlabel('Time(sec)');ylabel('Angle tracking error');

figure(2);
plot(t,ut(:,1),'k','linewidth',2);
xlabel('Time(sec)');ylabel('Control Input');

figure(3);
subplot(211);
plot(t,th(:,1),'k',t,0.025*time,'r:','linewidth',2);
xlabel('Time(sec)');ylabel('Estimation of ¦È_1');
subplot(212);
plot(t,th(:,2),'k',t,-2*time,'r:','linewidth',2);
xlabel('Time(sec)');ylabel('Estimation of ¦È_2');

figure(4);
subplot(211);
plot(t,th(:,3),'k',t,-0.125*time,'r:','linewidth',2);
xlabel('Time(sec)');ylabel('Estimation of ¦È_3');
subplot(212);
plot(t,th(:,4),'k',t,-5*time,'r:','linewidth',2);
xlabel('Time(sec)');ylabel('Estimation of ¦È_4');