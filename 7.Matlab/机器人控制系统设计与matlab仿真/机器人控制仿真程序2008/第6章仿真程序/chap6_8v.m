function [sys,x0,str,ts] = controller1(t,x,u,flag)
switch flag,
   case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
   case 3,
    sys=mdlOutputs(t,x,u);
   case {1,2,4,9}
    sys=[];
   otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1; 
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
persistent k p_1
c1=10;c2=10;

xe=u(1);ye=u(3);
dxd=u(2);dyd=u(4);

m1=dxd+c1*xe;
m2=dyd+c2*ye;
z=m1+m2*i;

p=angle(z);
if t==0
    k=0;
    p_1=p;
end

delta=-0.8*pi^2;  % Change nearly in -pi and +pi
if p*p_1<delta    % Guarantee p is in [0,2*pi]
   if p<0
      k=k+1;
   else
      k=k-1;
  end
end
p_1=p;
alfa=p+2*pi*k;

v=norm(z);
sys(1)=v;
sys(2)=alfa;