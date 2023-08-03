close all;

figure(1);
plot(t,r(:,1),'r',t,x(:,1),'b');
xlabel('time(s)');ylabel('Position tracking of link1');

figure(2);
plot(t,r(:,2),'r',t,x(:,3),'b');
xlabel('time(s)');ylabel('Position tracking of link2');

tao1=out(:,1);
tao2=out(:,2);
figure(3);
plot(t,tao1,'r');
xlabel('time(s)');ylabel('Control input of link1');

figure(4);
plot(t,tao2,'r');
xlabel('time(s)');ylabel('Control input of link2');

e1=out(:,3);
de1=out(:,4);
e2=out(:,5);
de2=out(:,6);

q=3;p=5;
figure(5);
plot(e1,de1,'r',e1,(abs(-e1)).^(q/p).*sign(-e1),'b');
xlabel('e1');ylabel('de1');

figure(6);
plot(e2,de2,'r',e2,(abs(-e2)).^(q/p).*sign(-e2),'b');
xlabel('e2');ylabel('de2');