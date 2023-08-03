clear all;
close all;

%%%%%%%%%%%%%%%%%%%%% Fuzzy System Design %%%%%%%%%%%%%%%%%%%%
a=newfis('fuzz_smc');

k1=1.0;
a=addvar(a,'input','s',[-3*k1,3*k1]);         % Parameter s
a=addmf(a,'input',1,'NB','zmf',[-3*k1,-1*k1]);
a=addmf(a,'input',1,'NM','trimf',[-3*k1,-2*k1,0]);
a=addmf(a,'input',1,'NS','trimf',[-3*k1,-1*k1,1*k1]);
a=addmf(a,'input',1,'Z','trimf',[-2*k1,0,2*k1]);
a=addmf(a,'input',1,'PS','trimf',[-1*k1,1*k1,3*k1]);
a=addmf(a,'input',1,'PM','trimf',[0,2*k1,3*k1]);
a=addmf(a,'input',1,'PB','smf',[1*k1,3*k1]);

k2=1.0;
a=addvar(a,'input','ds',[-3*k2,3*k2]);        % Parameter ds
a=addmf(a,'input',2,'NB','zmf',[-3*k2,-1*k2]);
a=addmf(a,'input',2,'NM','trimf',[-3*k2,-2*k2,0]);
a=addmf(a,'input',2,'NS','trimf',[-3*k2,-1*k2,1*k2]);
a=addmf(a,'input',2,'Z','trimf',[-2*k2,0,2*k2]);
a=addmf(a,'input',2,'PS','trimf',[-1*k2,1*k2,3*k2]);
a=addmf(a,'input',2,'PM','trimf',[0,2*k2,3*k2]);
a=addmf(a,'input',2,'PB','smf',[1*k2,3*k2]);

k3=1.0;
a=addvar(a,'output','du',[-3*k3,3*k3]);        % Parameter du
a=addmf(a,'output',1,'NB','zmf',[-3*k3,-1*k3]);
a=addmf(a,'output',1,'NM','trimf',[-3*k3,-2*k3,0]);
a=addmf(a,'output',1,'NS','trimf',[-3*k3,-1*k3,1*k3]);
a=addmf(a,'output',1,'Z','trimf',[-2*k3,0,2*k3]);
a=addmf(a,'output',1,'PS','trimf',[-1*k3,1*k3,3*k3]);
a=addmf(a,'output',1,'PM','trimf',[0,2*k3,3*k3]);
a=addmf(a,'output',1,'PB','smf',[1*k3,3*k3]);

rulelist=[1 1 1 1 1;    % Fuzzy rule base
          1 2 1 1 1;
          1 3 2 1 1;
          1 4 2 1 1;
          1 5 3 1 1;
          1 6 3 1 1;
          1 7 4 1 1;
   
          2 1 1 1 1;
          2 2 2 1 1;
          2 3 2 1 1;
          2 4 3 1 1;
          2 5 3 1 1;
          2 6 4 1 1;
          2 7 5 1 1;
          
          3 1 2 1 1;
          3 2 2 1 1;
          3 3 3 1 1;
          3 4 3 1 1;
          3 5 4 1 1;
          3 6 5 1 1;
          3 7 5 1 1;
          
          4 1 2 1 1;
          4 2 3 1 1;
          4 3 3 1 1;
          4 4 4 1 1;
          4 5 5 1 1;
          4 6 5 1 1;
          4 7 6 1 1;
          
          5 1 3 1 1;
          5 2 3 1 1;
          5 3 4 1 1;
          5 4 5 1 1;
          5 5 5 1 1;
          5 6 6 1 1;
          5 7 6 1 1;
          
          6 1 3 1 1;
          6 2 4 1 1;
          6 3 5 1 1;
          6 4 5 1 1;
          6 5 6 1 1;
          6 6 6 1 1;
          6 7 7 1 1;
       
          7 1 4 1 1;
          7 2 5 1 1;
          7 3 5 1 1;
          7 4 6 1 1;
          7 5 6 1 1;
          7 6 7 1 1;
          7 7 7 1 1];
          
a=addrule(a,rulelist);
%showrule(a)                        % Show fuzzy rule base
%ruleview(a)
a1=setfis(a,'DefuzzMethod','centroid');  % Defuzzy
writefis(a1,'fsmc');                % Save to fuzzy file "fsmc.fis"
a2=readfis('fsmc');

%%%%%%%%%%%%%%%%%%%%% Fuzzy SMC Control %%%%%%%%%%%%%%%%%%%%
ts=0.001;
sys=tf([133],[1,25,0]);
dsys=c2d(sys,ts,'z');
[num,den]=tfdata(dsys,'v');

e_1=0;de_1=0;s_1=0;
u_1=0.0;u_2=0.0;
y_1=0.0;y_2=0.0;

for k=1:1:2000
time(k)=k*ts;

M=1;
if M==1
   rin(k)=1;  %Step Signal
end
if M==2
   rin(k)=sign(sin(1*2*pi*k*ts));  %Square Signal
end
if M==3
   rin(k)=sin(2*2*pi*k*ts);  %Sine Signal
end

%Linear model
yout(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;

e(k)=rin(k)-yout(k);
de(k)=(e(k)-e_1)/ts;

c=15;
s(k)=c*e(k)+1*de(k);
s1(k)=s(k)-s_1;

du(k)=evalfis([s(k) s1(k)],a2);  %Fuzzy Slide Mode Controler
u(k)=u_1+du(k);

if u(k)>=10
   u(k)=10;
end
if u(k)<=-10
   u(k)=-10;
end

e_1=e(k);
de_1=de(k);
s_1=s(k);

u_2=u_1;u_1=u(k);
y_2=y_1;y_1=yout(k);
end
figure(1);
plot(time,rin,'r',time,yout,'b');
xlabel('time(s)');ylabel('rin,yout');
figure(2);
plot(e,de,'b',e,-c*e,'r');
xlabel('e');ylabel('de');
figure(3);
plot(time,s,'r');
xlabel('time(s)');ylabel('s');
figure(4);
plot(time,u,'r');
xlabel('time(s)');ylabel('u');

figure(5);
plotmf(a2,'input',1);
figure(6);
plotmf(a2,'input',2);
figure(7);
plotmf(a2,'output',1);