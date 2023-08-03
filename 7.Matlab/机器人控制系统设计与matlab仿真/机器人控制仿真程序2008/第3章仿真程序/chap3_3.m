%RBF identification
clear all;
close all;

alfa=0.05;
xite=0.5;      
x=[0,0]';

%The parameters design of Guassian Function
%The input of RBF (u(k),y(k)) must be in the effect range of Guassian function overlay

%The value of b represents the widenth of Guassian function overlay
Mb=1;
if Mb==1        %The width of Guassian function is moderate
    b=1.5*ones(4,1);   
elseif Mb==2    %The width of Guassian function is too narrow, most overlap of Guassian function is near to zero
    b=0.0005*ones(4,1);   
elseif Mb==3    %The width of Guassian function is too widew,  most overlap of Guassian function is near to one, 
                %h=1, RBF invalidate
    b=5000*ones(4,1);   
end

%The value of c represents the center position of Guassian function overlay
Mc=1;
if Mc==1
    c=0.5*ones(2,4);  %u(k)=0.50*sin(1*2*pi*k*ts) and y(k) are in the center of Guassian function overlay
elseif Mc==2
    c=0.4*ones(2,4);  %u(k)=0.50*sin(1*2*pi*k*ts) and y(k) are near to the center of Guassian function overlay
elseif Mc==3
    c=5*ones(2,4);   %u(k)=0.50*sin(1*2*pi*k*ts) and y(k) are far to the center of Guassian  function overlay
elseif Mc==4
    c=-5*ones(2,4);   %u(k)=0.50*sin(1*2*pi*k*ts) and y(k) are far to the center of Guassian  function overlay
end

w=rands(4,1);   
w_1=w;w_2=w_1;
y_1=0;

ts=0.001;
for k=1:1:2000
   
time(k)=k*ts;
u(k)=0.50*sin(1*2*pi*k*ts);

y(k)=u(k)^3+y_1/(1+y_1^2);  

x(1)=u(k);
x(2)=y(k);
   
for j=1:1:4
    h(j)=exp(-norm(x-c(:,j))^2/(2*b(j)*b(j)));
end
ym(k)=w'*h';
em(k)=y(k)-ym(k);

d_w=xite*em(k)*h';
w=w_1+ d_w+alfa*(w_1-w_2);
   
y_1=y(k);
w_2=w_1;w_1=w;
end
figure(1);
plot(time,y,'r',time,ym,'b');
xlabel('time(s)');ylabel('y and ym');