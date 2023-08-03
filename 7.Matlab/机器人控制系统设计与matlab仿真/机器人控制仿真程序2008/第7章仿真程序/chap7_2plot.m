close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
c=25;
plot(e(:,1),e(:,2),'r',e(:,1),-c*e(:,1),'b');
xlabel('e');ylabel('de');

figure(3);
plot(t,ut,'r');
xlabel('time(s)');ylabel('Control input');