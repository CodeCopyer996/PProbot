%Discrete RBF control for two-link manipulators
clear all;
close all;

ts=0.001;  %Sampling time
xk=[0 0 0 0];

tol1_1=0;
tol2_1=0;
ei=0;

node=5;
c_D=[-2 -1 0 1 2;    
     -1 -0.5 0 0.5 1];
c_C=[-2 -1 0 1 2;
     -1 -0.5 0 0.5 1;
     -2 -1 0 1 2;
     -1 -0.5 0 0.5 1];
c_G=[-2 -1 0 1 2;    
     -1 -0.5 0 0.5 1];
b=20.0;

W_D11_1=zeros(node,1);W_D12_1=zeros(node,1);
W_D21_1=zeros(node,1);W_D22_1=zeros(node,1);

W_C11_1=zeros(node,1);W_C12_1=zeros(node,1);
W_C21_1=zeros(node,1);W_C22_1=zeros(node,1);

W_G1_1=zeros(node,1);W_G2_1=zeros(node,1);

Hur=5*eye(2);
for k=1:1:5000
if mod(k,100)==1
   k
end
time(k) = k*ts;

qd1(k)=0.50*sin(1*2*pi*k*ts);
qd2(k)=0.50*sin(1*2*pi*k*ts);
d_qd1(k)=0.50*1*2*pi*cos(1*2*pi*k*ts);
d_qd2(k)=0.50*1*2*pi*cos(1*2*pi*k*ts);
dd_qd1(k)=-0.50*(1*2*pi)^2*sin(1*2*pi*k*ts);
dd_qd2(k)=-0.50*(1*2*pi)^2*sin(1*2*pi*k*ts);
    
para=[tol1_1 tol2_1];        %D/A
tSpan=[0 ts];

[t,xx]=ode45('chap3_13plant',tSpan,xk,[],para);

dx=chap3_13plant(tSpan,xk,[],para);  %A/D speed
xk = xx(length(xx),:);   %A/D position

q1(k)=xk(1); 
q2(k)=xk(3); 
dq1(k)=dx(1); 
dq2(k)=dx(3);

q=[q1(k);q2(k)];
z=[q1(k);q2(k);dq1(k);dq2(k)];

e1(k)=qd1(k)-q1(k);
d_e1(k)=d_qd1(k)-dq1(k); 
e2(k)=qd2(k)-q2(k);
d_e2(k)=d_qd2(k)-dq2(k); 

e=[e1(k);e2(k)];
d_e=[d_e1(k);d_e2(k)];

S=2;
if S==1     %PD control
	tol=400*e+50*d_e;
    tol1(k)=tol(1);
    tol2(k)=tol(2);
elseif S==2   %RBF control
    r=d_e+Hur*e;
    d_qd=[d_qd1(k);d_qd2(k)];
    d_qr=d_qd+Hur*e;
    dd_qd=[dd_qd1(k);dd_qd2(k)];
    dd_qr=dd_qd+Hur*d_e;
for j=1:1:node
    h_D11(j)=exp(-norm(q-c_D(:,j))^2/(b*b));
    h_D21(j)=exp(-norm(q-c_D(:,j))^2/(b*b));
    h_D12(j)=exp(-norm(q-c_D(:,j))^2/(b*b));
    h_D22(j)=exp(-norm(q-c_D(:,j))^2/(b*b));
end
for j=1:1:node
    h_C11(j)=exp(-norm(z-c_C(:,j))^2/(b*b));
    h_C21(j)=exp(-norm(z-c_C(:,j))^2/(b*b));
    h_C12(j)=exp(-norm(z-c_C(:,j))^2/(b*b));
    h_C22(j)=exp(-norm(z-c_C(:,j))^2/(b*b));
end
for j=1:1:node
    h_G1(j)=exp(-norm(q-c_G(:,j))^2/(b*b));
    h_G2(j)=exp(-norm(q-c_G(:,j))^2/(b*b));
end

T_D11=5*eye(node);
T_D21=5*eye(node);
T_D12=5*eye(node);
T_D22=5*eye(node);
T_C11=10*eye(node);
T_C21=10*eye(node);
T_C12=10*eye(node);
T_C22=10*eye(node);
T_G1=10*eye(node);
T_G2=10*eye(node);

for i=1:1:node
    W_D11(i,1)=W_D11_1(i,1)+ts*T_D11(i,i)*h_D11(i)*dd_qr(1)*r(1);
    W_D21(i,1)=W_D21_1(i,1)+ts*T_D21(i,i)*h_D21(i)*dd_qr(1)*r(2);
    W_D12(i,1)=W_D12_1(i,1)+ts*T_D12(i,i)*h_D12(i)*dd_qr(2)*r(1);
    W_D22(i,1)=W_D22_1(i,1)+ts*T_D22(i,i)*h_D22(i)*dd_qr(2)*r(2);
    
    W_C11(i,1)=W_C11_1(i,1)+ts*T_C11(i,i)*h_C11(i)*d_qr(1)*r(1);
    W_C21(i,1)=W_C21_1(i,1)+ts*T_C21(i,i)*h_C21(i)*d_qr(1)*r(2);
    W_C12(i,1)=W_C12_1(i,1)+ts*T_C12(i,i)*h_C12(i)*dd_qr(2)*r(1);
    W_C22(i,1)=W_C22_1(i,1)+ts*T_C22(i,i)*h_C22(i)*dd_qr(2)*r(2);
    
    W_G1=W_G1_1+ts*T_G1(i,i)*h_G1(i)*r(1);
    W_G2=W_G2_1+ts*T_G2(i,i)*h_G2(i)*r(2);
end
DSNN_g=[W_D11'*h_D11' W_D12'*h_D12';
        W_D21'*h_D21' W_D22'*h_D22'];
GSNN_g=[W_G1'*h_G1';
        W_G2'*h_G2'];
CDNN_g=[W_C11'*h_C11' W_C12'*h_C12';
        W_C21'*h_C21' W_C22'*h_C22'];
    
tol_m=DSNN_g*dd_qr+CDNN_g*d_qr+GSNN_g;

Kp=20;Ki=20;Kr=1.5;
ei=ei+e*ts;
tol=tol_m+Kp*r+Kr*sign(r)+Ki*ei;
tol1(k)=tol(1);
tol2(k)=tol(2);

W_D11_1=W_D11;
W_D21_1=W_D21;
W_D12_1=W_D12;
W_D22_1=W_D22;
W_C11_1=W_C11;
W_C21_1=W_C21;
W_C12_1=W_C12;
W_C22_1=W_C22;
W_G1_1=W_G1;
W_G2_1=W_G2;
end
    tol1_1=tol1(k);
    tol2_1=tol2(k);
end
figure(1);
subplot(211);
plot(time,qd1,'r',time,q1,'b');
xlabel('time(s)'),ylabel('Position tracking of link 1');
subplot(212);
plot(time,qd2,'r',time,q2,'b');
xlabel('time(s)'),ylabel('Position tracking of link 2');

figure(2);
subplot(211);
plot(time,tol1,'r');
xlabel('time(s)'),ylabel('Control input of link 1');
subplot(212);
plot(time,tol2,'r');
xlabel('time(s)'),ylabel('Control input of link 2');