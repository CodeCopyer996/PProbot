function dx=PlantModel(t,x,flag,para)
global S A F c alfa beta
dx=zeros(2,1);

S=1;
if S==1
   rin=1.0;
   drin=0;
elseif S==2
   A=0.5;F=3;
   rin=A*sin(F*2*pi*t);
   drin=A*F*2*pi*cos(F*2*pi*t);
end

c=30;
alfa=500;
beta=10;

e1=rin-x(1);
e2=drin-x(2);

s=c*e1+e2;
u=(alfa*abs(e1)+beta*abs(e2))*sign(s);

dx(1)=x(2);
dx(2)=-(25+5*sin(3*2*pi*t))*x(2)+(133+50*sin(1*2*pi*t))*u;