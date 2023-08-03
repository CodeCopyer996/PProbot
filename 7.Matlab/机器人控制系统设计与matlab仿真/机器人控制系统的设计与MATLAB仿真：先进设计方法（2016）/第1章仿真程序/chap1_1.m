clear all;
close all;
ts=0.001;
kb=0.501;

for k=1:1:1001;
    z(k)=(k-1)*ts-0.50;
    V(k)=0.5*log(kb^2/(kb^2-z(k)^2));
end

figure(1);
plot(z,V,'r','linewidth',2);
xlabel('z');ylabel('V');
legend('Barrier Lyapunov function');
hold on;
plot(-kb,[0:0.001:3],'k',kb,[0:0.001:3],'k');

XMIN=-0.6;XMAX=0.6;
YMIN=0;YMAX=3;
axis([XMIN XMAX YMIN YMAX]);