function dx=PlantModel(t,x,flag,para)
global A B
dx=zeros(2,1);

u=para;
dx=A*x+B*u;