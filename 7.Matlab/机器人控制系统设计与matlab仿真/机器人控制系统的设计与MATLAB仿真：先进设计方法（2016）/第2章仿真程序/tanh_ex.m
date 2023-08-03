clear all;
close all;

uM=5.0;
ts=0.01;
for k=1:1:4000;

v(k)=k*ts-20;

if abs(v(k))>=uM
    y1(k)=uM*sign(v(k));
else
    y1(k)=v(k);
end

y2(k)=uM*tanh(v(k)/uM);
end

figure(1);
plot(v,y1,'r',v,y2,'k','linewidth',2);
xlabel('v');ylabel('y');
legend('Switch function','Tanh function');