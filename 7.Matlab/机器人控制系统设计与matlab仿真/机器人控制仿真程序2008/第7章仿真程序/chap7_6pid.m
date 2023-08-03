function [sys,x0,str,ts] =PIDFcontroler_1(t,x,u,flag)

switch flag,
    case 0,
        [sys,x0,str,ts] = mdlInitializeSizes;
    case 3,
        sys = mdlOutputs(t,x,u);
    case {2,4,9}
        sys = [];
    otherwise
         error(['Unhandled flag = ',num2str(flag)]);
 end
 
function [sys,x0,str,ts] = mdlInitializeSizes
 sizes = simsizes;
 sizes.NumOutputs = 1;
 sizes.NumInputs = 4;
 sizes.DirFeedthrough = 1;
 sizes.NumSampleTimes = 1;
 sys = simsizes(sizes);
 x0 = [];
 str = [];
 ts = [0 0];
 
function sys = mdlOutputs(t,x,u)
kp = 30;
ki = 0;
kd = 0.5;
fm=u(4);

tolm = kp*u(1) + ki*u(2) + kd*u(3);
sys(1) = tolm;