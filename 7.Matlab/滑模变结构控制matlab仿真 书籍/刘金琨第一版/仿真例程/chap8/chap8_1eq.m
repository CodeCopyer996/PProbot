function dx=PlantModel(t,x,flag,para)
dx=zeros(2,1);

at=3*sin(t);
z0=1.0;
L=10;

dx(1)=z0+at;
dx(2)=z0+L*sign(x(1)-x(2));