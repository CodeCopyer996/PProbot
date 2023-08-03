close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('position tracking');

figure(2);
c=10;
plot(e,de,'r',e,-c*e,'b');
xlabel('e');ylabel('de');

figure(3);
plot(t,u,'r');
xlabel('time(s)');ylabel('control input');