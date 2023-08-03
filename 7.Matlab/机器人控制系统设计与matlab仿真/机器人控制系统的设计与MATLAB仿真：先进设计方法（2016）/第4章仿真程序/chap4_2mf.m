clear all;
close all;
 
L1=-5;
L2=5;
L=L2-L1;

T=L*1/1000;

x=L1:T:L2;
figure(1);
for i=1:1:3
    gs=-0.5*((x+(i-2)*1.25)/0.6).^2;
	u=exp(gs);
	hold on;
	plot(x,u);
end
xlabel('x');ylabel('Membership function degree');