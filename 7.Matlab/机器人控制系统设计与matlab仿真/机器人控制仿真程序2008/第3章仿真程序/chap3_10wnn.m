function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
global S T k1 k2 node c1 c2 b
S=200;T=500;
k1=0.001;k2=0.0001;
node=10;

b=20;
c1=[-2 -1 0 1 2 3 4 5 6 7];
c2=[-2 -1 0 1 2 3 4 5 6 7];

sizes = simsizes;
sizes.NumContStates  = 2*node;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0=[100*ones(node,1);100*ones(node,1)];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)
global S T k1 k2 node c1 c2 b
w=u(1);
r=u(2);
ut=u(3);

%NNI
h1=zeros(node,1);
for j=1:1:node
    h1(j)=exp(-(ut-c1(j))^2/(b*b));
end
  
%NNII
h2=zeros(node,1);
for j=1:1:node
    h2(j)=exp(-(w-c2(j))^2/(b*b));
end

dh1=zeros(node,1);
for i=1:1:node    
    dh1(i)=h1(i)*(-2*(ut-c1(i))/b^2);
end

for i=1:1:node
    W(i)=x(i);
    Wi(i)=x(i+node);
end
d_W=-S*dh1*Wi*h2*r'-k1*S*norm(r)*W';
d_Wi=T*h2*r'*W*dh1-k1*T*norm(r)*Wi'-k2*T*norm(r)*norm(Wi)*Wi';

sys(1:node)=d_W';
sys(node+1:2*node)=d_Wi';
function sys=mdlOutputs(t,x,u)
global S T k1 k2 node c1 c2 b
w=u(1);
r=u(2);
ut=u(3);

%NNI
h1=zeros(node,1);
for j=1:1:node
    h1(j)=exp(-(ut-c1(j))^2/(b*b));
end
  
%NNII
h2=zeros(node,1);
for j=1:1:node
    h2(j)=exp(-(w-c2(j))^2/(b*b));
end

for i=1:1:node
     Wi(i)=x(i+node);
end
sys=Wi*h2;