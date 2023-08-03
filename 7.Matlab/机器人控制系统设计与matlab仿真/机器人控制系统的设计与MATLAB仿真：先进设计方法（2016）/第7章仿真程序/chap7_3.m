close all;
clear all;
nx=10;
nt=20000;

tmax=10;L=1;
%Compute mesh spacing and time step
dx=L/(nx-1); 
T=tmax/(nt-1);

%Create arrays to save data for export
t=linspace(0,nt*T,nt);
x=linspace(0,L,nx);

%Parameters
EI=3;rho=0.2;m=0.1;Ih=0.1;
kp=50;kd=30;k=20;

dthd=0;ddthd=0;

dzL_1=0;
zxxxL_1=0;

dzx_1=0;
zxxxx_1=0;
F_1=0;
%Define viriables and Initial condition:
y=zeros(nx,nt); 
z=zeros(nx,nt);   %elastic deflectgion
th_2=0;th_1=0;
dth_1=0;

for j=1:nt
    th(j)=0;     %joint angle
    thd(j)=0.5;  %desired angle
    tol(j)=0;
    F(j)=0;
end

for j=3:nt    %Begin
e=th(j-1)-thd(j-1);
de=dth_1-dthd;

tol(j-1)=-kp*e-kd*de;

yxx0=(y(3,j-1)-2*y(2,j-1)+y(1,j-1))/dx^2;
zxx0=yxx0;
th(j)=2*th(j-1)-th(j-2)+T^2/Ih*(tol(j-1)+EI*zxx0);     %(A1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%z(i,j)
dth(j)=(th(j)-th(j-1))/T;
ddth(j)=(th(j)-2*th(j-1)+th(j-2))/T^2;

%get z(i,j),i=1,2, Boundary conditions  (A2)
y(1,:)=0;    %y(0,t)=0, i=1
y(2,:)=0;    %y(1,t)=0, i=2
z(1,:)=0;    %y(0,t)=0, i=1
z(2,:)=0;    %y(1,t)=0, i=2

%get y(i,j),i=3:nx-2 
for i=3:nx-2              
   yxxxx=(y(i+2,j-1)-4*y(i+1,j-1)+6*y(i,j-1)-4*y(i-1,j-1)+y(i-2,j-1))/dx^4;
   y(i,j)=T^2*(-i*dx*ddth(j)-(EI*yxxxx)/rho)+2*y(i,j-1)-y(i,j-2);    %(A3)
   zxxxx(i,j-1)=yxxxx;%i*dx=x,plant (6) and (17)
   
   dy(i,j-1)=(y(i,j-1)-y(i,j-2))/T;
   dzx(i,j-1)=i*dx*dth(j-1)+dy(j-1);
end

%get z(nx-1,j),i=nx-1
yxxxx(nx-1,j-1)=(-2*y(nx,j-1)+5*y(nx-1,j-1)-4*y(nx-2,j-1)+y(nx-3,j-1))/dx^4;
y(nx-1,j)=T^2*(-(nx-1)*dx*ddth(j)-EI*yxxxx(nx-1,j-1)/rho)+2*y(nx-1,j-1)-y(nx-1,j-2);  %(A6)
zxxxx(nx-1,j-1)=yxxxx(nx-1,j-1);
dy(nx-1,j)=(y(nx-1,j)-y(nx-1,j-1))/T;

%dzx(nx-1,j)=(nx-1)*dx*dth(j)+dyx(nx-1,j);
%get y(nx,j),y=nx
yxxxL(j-1)=(-y(nx,j-1)+2*y(nx-1,j-1)-y(nx-2,j-1))/dx^3;
y(nx,j)=T^2*(-L*ddth(j-1)+(EI*yxxxL(j-1)+F_1)/m)+2*y(nx,j-1)-y(nx,j-2);      %(A7)

dy(nx,j)=(y(nx,j)-y(nx,j-1))/T;
zxxxL(j-1)=yxxxL(j-1);

dyL(j-1)=(y(nx,j-1)-y(nx,j-2))/T;
dzL(j-1)=L*dth(j-1)+dyL(j-1);

dzxxx_L=(yxxxL(j-1)-yxxxL(j-2))/T; 
F(j-1)=-k*dzL(j-1); 

F_1=F(j-1);
dth_1=dth(j);
dzL_1=dzL(j-1);
zxxxL_1=zxxxL(j-1);
end   %End
%To view the curve, short the points
tshort=linspace(0,tmax,nt/100);
yshort=zeros(nx,nt/100);
dyshort=zeros(nx,nt/100);
for j=1:nt/100
      for i=1:nx
          yshort(i,j)=y(i,j*100);     %Using true y(i,j)
          dyshort(i,j)=dy(i,j*100);   %Using true dy(i,j)          
      end
end
figure(1);
subplot(211);
plot(t,thd,'r',t,th,'k','linewidth',2);
xlabel('Time (s)');ylabel('Angle tracking (rad)');
legend('thd','th');
axis([0 10 0 0.7]);
subplot(212);
plot(t,dth,'k','linewidth',2);
xlabel('Time (s)');ylabel('Angle speed response (rad/s)');
legend('dth');
 
figure(2);
subplot(211);
surf(tshort,x,yshort);
xlabel('Time (s)'); ylabel('x');zlabel('Deflection, y(x,t) (m)');
axis([0 10 0 1 -0.02 0.02]);
subplot(212);
surf(tshort,x,dyshort);
xlabel('Time (s)'); ylabel('x');zlabel('Deflection rate, dy(x,t) (m/s)');

figure(3);
subplot(211);
plot(t,tol,'r','linewidth',2);
xlabel('Time (s)');ylabel('Control input, tol (Nm)'); 
axis([0 10 -10 30]);
subplot(212);
plot(t,F,'r','linewidth',2);
xlabel('Time (s)');ylabel('Control input, F (N)');
axis([0 10 -20 20]);