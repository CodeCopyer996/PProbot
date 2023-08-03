close all;

figure(1);
subplot(311);
plot(t,gama(:,1),'r',t,gama(:,2),'b');
xlabel('time(s)');ylabel('Angle tracking of rolling');
subplot(312);
plot(t,Fai(:,1),'r',t,Fai(:,2),'b');
xlabel('time(s)');ylabel('Angle tracking of yawing');
subplot(313);
plot(t,fai(:,1),'r',t,fai(:,2),'b');
xlabel('time(s)');ylabel('Angle tracking of pitching');

figure(2);
subplot(311);
plot(t,wc(:,1),'b');
xlabel('time(s)');ylabel('Angle speed order of rolling');
subplot(312);
plot(t,wc(:,2),'r');
xlabel('time(s)');ylabel('Angle speed order of yawing');
subplot(313);
plot(t,wc(:,3),'k');
xlabel('time(s)');ylabel('Angle speed order of pitching');

figure(3);
subplot(311);
plot(t,M(:,1),'b');
xlabel('time(s)');ylabel('Control input of rolling');
subplot(312);
plot(t,M(:,2),'r');
xlabel('time(s)');ylabel('Control input of yawing');
subplot(313);
plot(t,M(:,3),'k');
xlabel('time(s)');ylabel('Control input of pitching');

figure(4);
subplot(211);
plot(t,sn(:,1),'r');
xlabel('time(s)');ylabel('Inner sliding function ');
subplot(212);
plot(t,sw(:,1),'r');
xlabel('time(s)');ylabel('Outer sliding function ');