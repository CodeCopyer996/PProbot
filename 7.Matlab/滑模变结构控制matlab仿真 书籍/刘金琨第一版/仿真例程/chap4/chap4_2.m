clear all;
close all;
%%%%%%%% Fuzzy System Design %%%%%%%%%%%
a=newfis('fuzz');

k1=1.0;
a=addvar(a,'input','s',[-3*k1,3*k1]);
a=addmf(a,'input',1,'NB','zmf',[-3*k1,-1*k1]);
a=addmf(a,'input',1,'Z','trimf',[-2*k1,0,2*k1]);
a=addmf(a,'input',1,'PB','smf',[1*k1,3*k1]);

k2=1.0;
a=addvar(a,'input','ds',[-3*k2,3*k2]);
a=addmf(a,'input',2,'NB','zmf',[-3*k2,-1*k2]);
a=addmf(a,'input',2,'Z','trimf',[-2*k2,0,2*k2]);
a=addmf(a,'input',2,'PB','smf',[1*k2,3*k2]);

k3=1.0;
a=addvar(a,'output','eq',[-3*k3,3*k3]);
a=addmf(a,'output',1,'NB','zmf',[-3*k3,-1*k3]);
a=addmf(a,'output',1,'Z','trimf',[-2*k3,0,2*k3]);
a=addmf(a,'output',1,'PB','smf',[1*k3,3*k3]);

rulelist=[1 1 1 1 1;   % Edit rule base
          1 2 1 1 1;
          1 3 2 1 1;
   
          2 1 1 1 1;
          2 2 2 1 1;
          2 3 2 1 1;
          
          3 1 2 1 1;
          3 2 2 1 1;
          3 3 3 1 1];
          
a=addrule(a,rulelist);
%showrule(a)                        % Show fuzzy rule base
%ruleview(a)
a1=setfis(a,'DefuzzMethod','centroid');  % Defuzzy
writefis(a1,'fuzz');
a2=readfis('fuzz');

%%%%%%%% Fuzzy SMC Control %%%%%%%%%%%
ts=0.001;
A1=[0,1;0,-25];
B1=[0;133];
C1=[1,0];
D1=0;
[A,B,C,D]=c2dm(A1,B1,C1,D1,ts,'z');

x=[0;0];
r_1=0;r_2=0;

c=10;
q=30;
Ce=[c,1];
es_1=0;

for k=1:1:1000
   
	time(k)=k*ts;
   r(k)=1.0;
   
   %Using Waitui method   
   dr(k)=(r(k)-r_1)/ts;
   dr_1=(r_1-r_2)/ts;
   r1(k)=2*r(k)-r_1;
   dr1(k)=2*dr(k)-dr_1;
  
R=[r(k);dr(k)];
R1=[r1(k);dr1(k)];
   
E=R-x;
e(k)=E(1);
de(k)=E(2);
   
s(k)=Ce*E;
 
es(k)=s(k);
des(k)=es(k)-es_1; 

fs(k)=evalfis([es(k) des(k)],a2);     %Using fuzzy inference
   
M=2;
if M==1      %EXP trending law with fixed eq
	eq(k)=5.0;
elseif M==2  %EXP trending law with adaptive eq
	eq(k)=abs(fs(k));
end

ds(k)=-eq(k)*ts*sign(s(k))-q*ts*s(k);
u(k)=inv(Ce*B)*(Ce*R1-Ce*A*x-s(k)-ds(k));
   
if u(k)>=10
   u(k)=10;
end
if u(k)<=-10
   u(k)=-10;
end

x=A*x+B*u(k);
y(k)=x(1);

%Update Parameters
r_2=r_1;
r_1=r(k);
es_1=es(k);
end
figure(1)
plot(time,r,'r',time,y,'b');
xlabel('Time(second)');ylabel('Step response');

figure(2)
plot(e,de,'r',e,-c*e,'b');
xlabel('e');ylabel('de');

figure(3)
plot(time,u,'r');
xlabel('Time(second)');ylabel('u');

figure(4)
plot(time,eq,'r');
xlabel('time(s)');ylabel('adaptive eq');

figure(5);
plotmf(a2,'input',1);
figure(6);
plotmf(a2,'input',2);
figure(7);
plotmf(a2,'output',1);