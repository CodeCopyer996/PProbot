function dx=DynamicModel(t,x,flag,para)
thd=sin(t);
dthd=cos(t);
ddthd=-sin(t);

th=x(1);
dth=x(2);

c=15;
e=thd-th;
de=dthd-dth;
s=c*e+de;

D=15;
xite=0.50;

fx=25*dth;
b=133;
u=1/b*(c*(dthd-dth)+ddthd+fx+(D+xite)*sign(s));

dx=zeros(2,1);
dt=15*sin(t);
dx(1)=x(2);
dx(2)=-25*x(2)+133*u+dt; 