close all;
figure(1); %编队控制,3条运动轨迹
plot(x(:,1),x(:,2),'b','linewidth',1);
hold on;
plot(x(:,4),x(:,5),'g','linewidth',1);
hold on;
plot(x(:,7),x(:,8),'y','linewidth',1);
hold on;

%在时间为600处的编队
%第1个移动机器人
plot(x(1,1),x(1,2),'k>');           %初始时刻第1个移动机器人
text(x(1,1)-0.4,x(1,2)+1.5,'p_1');  %初始时刻p_1的标记位置
hold on;
plot(x(600,1),x(600,2),'k*');       %在时间为600处第1个移动机器人
text(x(600,1)+0.2,x(600,2),'p_1');  %在时间为600处p_1的标记位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%第2个移动机器人
plot(x(1,4),x(1,5),'k>');            %初始时刻第2个移动机器人
text(x(1,4)-1.4,x(1,5)+0.2,'p_2');   %初始时刻p_2的标记位置
hold on;
plot(x(600,4),x(600,5),'k*');        %在时间为600处的第2个移动机器人
text(x(600,4)+0.2,x(600,5),'p_2');   %在时间为600处p_2的标记位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%第3个移动机器人
plot(x(1,7),x(1,8),'k>'); 
text(x(1,7)+0.2,x(1,8),'p_3'); 
hold on;
plot(x(600,7),x(600,8),'k*'); %在时间为600处的第3个移动机器人
text(x(600,7)+0.2,x(600,8),'p_3'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%在时间为600处的编队框图
a=[x(600,1),x(600,4),x(600,7),x(600,1)];
b=[x(600,2),x(600,5),x(600,8),x(600,2)];
plot(a,b,'mx-')

xlabel('x');ylabel('y');
legend('p_1','p_2','p_3');
title('formation process of three robots');

%在时间为1600处的编队
%第1个移动机器人
plot(x(1000,1),x(1000,2),'k*');      %在时间为1600处第1个移动机器人
text(x(1000,1)+0.2,x(1000,2),'p_1'); %在时间为1600处p_1的标记位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%第2个移动机器人
plot(x(1000,4),x(1000,5),'k*');  %在时间为1600处的第2个移动机器人
text(x(1000,4)+0.2,x(1000,5),'p_2');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%第3个移动机器人
plot(x(1000,7),x(1000,8),'k*');   %在时间为1600处的第3个移动机器人
text(x(1000,7)+0.2,x(1000,8),'p_3'); 
%%%%%%%%%%%%%%%%%%%%%%%%
%在时间为1600处的编队框图
a=[x(1000,1),x(1000,4),x(1000,7),x(1000,1)];
b=[x(1000,2),x(1000,5),x(1000,8),x(1000,2)];
plot(a,b,'mx-')

xlabel('x');ylabel('y');
legend('p_1','p_2','p_3');
title('formation process of three robots');
%%%%%%%%%%%%%%%%%%%%%%%%

%角度随动跟踪
figure(2);
subplot(311);
plot(t,thd1(:,1),'r',t,x(:,3),'b--','linewidth',2);
xlabel('time(s)');ylabel('\theta_{1d} tracking');
legend('\theta_{1d}','\theta_{1d} tracking');
title('\theta_{1d} tracking');
subplot(312);
plot(t,thd2(:,1),'r',t,x(:,6),'b--','linewidth',2);
xlabel('time(s)');ylabel('\theta_{2d} tracking');
legend('\theta_{2d}','\theta_{2d} tracking');
title('\theta_{2d} tracking');
subplot(313);
plot(t,thd3(:,1),'r',t,x(:,9),'b--','linewidth',2);
xlabel('time(s)');ylabel('\theta_{3d} tracking');
legend('\theta_{3d}','\theta_{3d} tracking');
title('\theta_{3d} tracking');

%速度跟踪
figure(3)
subplot(211);
plot(t,sudu1(:,1),'r',t,sudu2(:,1),'b',t,sudu3(:,1),'g',t,vd(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('v_{dx} tracking');
legend('v_{1x}','v_{2x}','v_{3x}','v_{dx}');
title('velocity tracking in the direction of x');
subplot(212);
plot(t,sudu1(:,2),'r',t,sudu2(:,2),'b',t,sudu3(:,2),'g',t,vd(:,2),'k','linewidth',2);
xlabel('time(s)');ylabel('v_{dy} tracking');
legend('v_{1y}','v_{2y}','v_{3y}','v_{dy}');
title('velocity tracking in the direction of y');