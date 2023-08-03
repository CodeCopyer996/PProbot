%RBF identification
clear all;
close all;
sys=tf(5.235e005,[1,87.35,1.047e004,0]);
dsys=c2d(sys,0.001,'z');
[num,den]=tfdata(dsys,'v');

alfa=0.05;
xite=0.35;      
x=[0,0,0]';

%bi=rands(4,1);   
%ci=rands(3,4);   
%w=rands(4,1);   

bi=[-2.1268;
    -0.2870;
     0.8481;
    -1.7593];
ci=[-0.4568    0.2089   -0.7983    3.5261;
    -0.3263   -0.4569    0.3854    3.0545;
    -0.3475   -0.6040   -0.0453    2.8705];
w=[ 0.3392
    0.0467
   -0.8302
    4.5379];
w_1=w;w_2=w_1;w_3=w_1;

ci_1=ci;ci_2=ci_1;
bi_1=bi;bi_2=bi_1;

y_1=0;y_2=0;y_3=0;
u_1=0.0;u_2=0.0;u_3=0.0;

ts=0.001;
%Main Program
for k=1:1:2000
   
time(k)=k*ts;
u(k)=0.50*sin(1*2*pi*k*ts);

if k<=1000
	yout(k)=u(k)^3+y_1/(1+y_1^2);  
else
	yout(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+num(3)*u_2+num(4)*u_3;%Linear control
end
x(3)=y_2;
x(2)=y_1;
x(1)=u_1;
   
for j=1:1:4
    h(j)=exp(-norm(x-ci_1(:,j))^2/(2*bi_1(j)*bi_1(j)));
end
ymout(k)=w_1'*h';
    
d_w=0*w;d_bi=0*bi;d_ci=0*ci;

for j=1:1:4
   d_w(j)=xite*(yout(k)-ymout(k))*h(j);
   d_bi(j)=xite*(yout(k)-ymout(k))*w_1(j)*h(j)*(bi_1(j)^-3)*norm(x-ci_1(:,j))^2;
  for i=1:1:3
   d_ci(i,j)=xite*(yout(k)-ymout(k))*w_1(j)*h(j)*(x(i)-ci_1(i,j))*(bi_1(j)^-2);
  end
end
   w=w_1+ d_w+alfa*(w_1-w_2);
   bi=bi_1+d_bi+alfa*(bi_1-bi_2);
   ci=ci_1+d_ci+alfa*(ci_1-ci_2);
   
   u_3=u_2;
   u_2=u_1;
   u_1=u(k);
   
   y_3=y_2;
   y_2=y_1;
   y_1=yout(k);
   
   w_2=w_1;
   w_1=w;
   
   ci_2=ci_1;
   ci_1=ci;
   
   bi_2=bi_1;
   bi_1=bi;
   end
   figure(1);
   plot(time,ymout,'r',time,yout,'b');
   xlabel('time(s)');
   ylabel('y and ym');
   
   figure(2);
   plot(time,ymout-yout,'r');
   xlabel('time(s)');
   ylabel('identification error');