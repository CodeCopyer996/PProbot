clear all;
close all;
ts=0.001;
for k=1:1:1000   
v(k)=3*sin(2*k*ts*pi);

gamas=0.05;
gamaf=0.3;
nius=gamas*sign(v(k));
niuf=gamaf*exp(-3.6*abs(v(k)))*sign(v(k));

eta=0.50;
if abs(v(k))>eta
    nmn=1;
else
    nmn=0;
end
f(k)=nius*nmn+niuf*(1-nmn);
end
figure(1);
plot(v,f,'r');
xlabel('speed');ylabel('Friction force');