close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,P(:,1),'r');
xlabel('time(s)');ylabel('control input');

figure(3);
plot(t,P(:,2),'r',t,P(:,3),'b',t,P(:,4),'k',t,P(:,5),'y',t,P(:,6),'m');
xlabel('time(s)');ylabel('Radias function output hj');