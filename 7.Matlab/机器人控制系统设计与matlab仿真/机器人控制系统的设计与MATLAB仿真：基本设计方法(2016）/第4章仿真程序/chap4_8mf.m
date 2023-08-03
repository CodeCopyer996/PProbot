clear all;
close all;
L1=-pi;L2=pi;
L=L2-L1;

h=pi/2;
N=L/h;
T=0.01;

x=L1:T:L2;
for i=1:N+1
    e(i)=L1+L/N*(i-1);
end
figure(2);
% h1
h1=trimf(x,[e(2),e(3),e(4)]);        %Rule 1:x1 is to zero
plot(x,h1,'r','linewidth',2);
% h2, Rule 2: x1 is about +-pi/2,but smaller
%if x<=0
   h2=trimf(x,[e(2),e(2),e(3)]);
hold on
plot(x,h2,'b','linewidth',2);
%else
   h2=trimf(x,[e(3),e(4),e(4)]);      
hold on
plot(x,h2,'b','linewidth',2);
%end

% h3, Rule 3: x1 is about +-pi/2,but bigger
%if x<0
    h3=trimf(x,[e(1),e(2),e(2)]);
hold on;
plot(x,h3,'g','linewidth',2);
%else
    h3=trimf(x,[e(4),e(4),e(5)]);
hold on;
plot(x,h3,'g','linewidth',2);
%end

% h4, Rule 4: x1 is about +-pi
%if x<0
    h4=trimf(x,[e(1),e(1),e(2)]); 
    hold on;
    plot(x,h4,'k','linewidth',2);
% else
    h4=trimf(x,[e(4),e(5),e(5)]); 
    hold on;
 plot(x,h4,'k','linewidth',2);
%end