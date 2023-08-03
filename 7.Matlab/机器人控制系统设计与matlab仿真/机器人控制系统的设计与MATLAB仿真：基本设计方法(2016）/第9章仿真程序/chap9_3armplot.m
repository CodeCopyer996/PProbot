close all;

q1=q(:,7);
q2=q(:,9);

l1=0.25;l2=0.25;
k=size(q(:,7));
for i=1:30:k
x_joint1=l1*cos(q1(i));
y_joint1=l1*sin(q1(i));
x_joint2=l1*cos(q1(i))+l2*cos(q1(i)+q2(i));
y_joint2=l1*sin(q1(i))+l2*sin(q1(i)+q2(i));
X=[0,x_joint1,x_joint2];
Y=[0,y_joint1,y_joint2];
plot(X,Y,'b')
hold on
end
plot(pd(:,1),pd(:,2),'r');
grid on
xlabel('x');ylabel('y');
