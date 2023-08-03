close all;

figure(1);
plot(t,fm,'r',t,fs,'b');
xlabel('time(s)');ylabel('fm,fs');

figure(2);
plot(t,xm,'r',t,xs,'b');
xlabel('time(s)');ylabel('xm,xs');

figure(3);
plot(t,tolm,'r');
xlabel('time(s)');ylabel('tolm');

figure(4);
plot(t,tols,'r');
xlabel('time(s)');ylabel('tols');

figure(5);
plot(t,s,'r');
xlabel('time(s)');ylabel('sliding mode function');