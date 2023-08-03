clear all;
close all;
T=0.001;

x=-pi/9:T:pi/9;
figure(1);
for i=1:1:2
    if i==1
       niux=1./(1+exp(-30*x));
    elseif i==2
       niux=1./(1+exp(30*x));
    end
	hold on;
	plot(x,niux);
end
xlabel('x');ylabel('Membership function degree of x');

u=-5:T:5;
figure(2);
for i=1:1:3
    if i==1
       niuu=exp(-(u+5).^2);
    elseif i==2
       niuu=exp(-u.^2);
    elseif i==3
       niuu=exp(-(u-5).^2);
    end
	hold on;
	plot(u,niuu);
end
xlabel('u');ylabel('Membership function degree of u');