close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(Ff(:,1),Ff(:,2),'r');
xlabel('Angle speed');ylabel('Friction force');

figure(3);
plot(t,dy(:,1),'r',t,dy(:,2),'b');
xlabel('time(s)');ylabel('Speed tracking');

figure(4);
c=30;
plot(e(:,1),e(:,2),'r',e(:,1),-c*e(:,1),'b');
xlabel('e');ylabel('de');

figure(5);
plot(t,ut,'r');
xlabel('time(s)');ylabel('Control input');