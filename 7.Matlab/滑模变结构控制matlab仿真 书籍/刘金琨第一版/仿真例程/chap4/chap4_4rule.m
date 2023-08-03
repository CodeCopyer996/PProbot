%S-function for continuous state equation
function [sys,x0,str,ts]=s_function(t,x,u,flag)

switch flag,
%Initialization
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
%Outputs
  case 3,
    sys=mdlOutputs(t,x,u);
%Unhandled flags
  case {2, 4, 9 }
    sys = [];
%Unexpected flags
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

%mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[];
str=[];
ts=[];

function sys=mdlOutputs(t,x,u)
persistent a1

if t==0
a=newfis('smc_fuzz');

f1=5;%500/3;
a=addvar(a,'input','sds',[-3*f1,3*f1]);    % Parameter e
a=addmf(a,'input',1,'NB','zmf',[-3*f1,-1*f1]);
a=addmf(a,'input',1,'NM','trimf',[-3*f1,-2*f1,0]);
a=addmf(a,'input',1,'Z','trimf',[-2*f1,0,2*f1]);
a=addmf(a,'input',1,'PM','trimf',[0,2*f1,3*f1]);
a=addmf(a,'input',1,'PB','smf',[1*f1,3*f1]);

f2=0.5;%0.5;%200/3;
a=addvar(a,'output','dk',[-3*f2,3*f2]);    %Parameter u
a=addmf(a,'output',1,'NB','zmf',[-3*f2,-1*f2]);
a=addmf(a,'output',1,'NM','trimf',[-2*f2,-1*f2,0]);
a=addmf(a,'output',1,'Z','trimf',[-1*f2,0,1*f2]);
a=addmf(a,'output',1,'PM','trimf',[0,1*f2,2*f2]);
a=addmf(a,'output',1,'PB','smf',[1*f2,3*f2]);

rulelist=[1 1 1 1;   %Edit rule base
          2 2 1 1;    
          3 3 1 1;    
          4 4 1 1;
          5 5 1 1];    
         
a1=addrule(a,rulelist);
a1=setfis(a1,'DefuzzMethod','centroid');  %Defuzzy
writefis(a1,'smc_fuzz');
                                      
a1=readfis('smc_fuzz');

flag=1;
if flag==1
figure(1);
plotmf(a1,'input',1);
figure(2);
plotmf(a1,'output',1);
end
end

sys(1)=evalfis([u(1)],a1);