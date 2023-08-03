clear all;
close all;
 
L1=-5;
L2=5;
L=L2-L1;

T=L*1/1000;

x=L1:T:L2;
figure(1);
for i=1:1:9
    gs=-0.5*(x-2+(i-1)*0.5).^2;
	u=exp(gs);
	hold on;
	plot(x,u);
end
xlabel('x');ylabel('Membership function degree');