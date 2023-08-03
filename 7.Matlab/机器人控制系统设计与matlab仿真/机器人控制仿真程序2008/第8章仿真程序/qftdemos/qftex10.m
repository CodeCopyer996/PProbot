% QFTEX10 Inverted pendulum.

% Author: O. Yaniv, Y. Chait
% 2/15/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

clc
clear
echo on

% Example #10 (inverted pendulum) describes the application of QFT to a
% feedback design problem with a parametrically uncertain flexible
% mechanical system with both open-loop instability and pure time delay.

% Please refer to manual for more details....

% Strike any key to advance from one plot to another....
pause % Strike any key to continue
clc

%	Consider a continuous-time, siso, negative unity feedback system

%                                   |V(s)            |D(s)
%                         ----      |      ----      |
%             ---->x---->|G(s)|---->x---->|P(s)|---->x---->
%             R(s) |      ----             ----        | Y(s)
%                  |               --                  |
%                  ---------------|-1|------------------
%                                  --

%       The plant P(s) (motor current to pendulum angle)
%       has a parametric uncertainty model:
%	        |    K*a             wn^2       s^2                   |
%	P(s)  = {------------ ----------------- -------  exp^(-s*tau) }
%	        |s(s+a)-K*k*a s^2+2*z*wn*s+wn^2 L*s^2-g               |

%       L in [0.35,0.45] m, K in [1.5,1.7] m/v/s, a in [15,17]
%       wn in [50,70] r/s, z in [0.01,0.02], tau=0.014 s
%       g=9.81 m/s^2, k=11 v/m

pause % Strike any key to continue
clc

%	The performance specifications are: design a controller
%  G(s) such that it achieves

%  1) Robust stability

%  2) Robust margins (via closed-loop magnitude peaks)
%         | P(jw)G(jw) |
%         |------------| < 2.1,  w>0
%         |1+P(jw)G(jw)|

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA

disp('Computing plant templates (32 cases at 16 frequencies)...')
drawnow
% Computing plant templates
ll=[.3 .45]; kk=[1.5 1.7]; aa=[15 17]; ww=[50 70];
xx=[.01 .02]; kpf=.1; g=9.8;
j=1;
for l=ll,
  for k=kk,
    for alfa=aa,
      for wn=ww,
        for xi=xx,
           nump(j,:) = k*alfa*wn^2*(1/l)*[1 0 0];
           dddd = conv([1 alfa -kpf*k*alfa],[1 2*xi*wn wn^2]);
           denp(j,:) = conv(dddd,[1 0 -g/l]);
           j=j+1;
        end
      end
    end
  end
end
nom=1;
% Compute frequency response
w=[0.1 0.2 0.5 1 2 5 10 30 35 40 42 47 49 50 60 70];
td=.014;  % time delay
P=freqcp(nump,denp,w,td);

disp(' ')
disp('plottmpl(w,wb,P,nom); %show templates')
drawnow
wb=[1 10 42 47 49 50 60 70];
plottmpl(w,wb,P,nom),title('Plant Templates')
qpause;close(gcf);

% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')
disp('bdb1=sisobnds(1,w,wbd,W1,P,R,nom); %margins');
drawnow
R = 0;
W1=2.1;
wbd=w;
% split bound computation into 4 steps (reduces memory requirement)
bdb1a=sisobnds(1,w,wbd(1:5),W1,P,R);
bdb1b=sisobnds(1,w,wbd(6:10),W1,P,R);
bdb1c=sisobnds(1,w,wbd(11:16),W1,P,R);
bdb1=[bdb1a,bdb1b,bdb1c];
disp('plotbnds(bdb1); %show bounds')
drawnow
plotbnds(bdb1),title('Robust Margins Bounds');
qpause,close(gcf);

% DESIGN
disp(' ')
disp('Design')
disp('lpshape(wl,bdb1,nL0,dL0,del0,nc0,dc0); %loop shaping')
drawnow
nL0=nump(nom,:); dL0=denp(nom,:);  % nominal plant
wl=logspace(-2,log10(150),200);
nc0=[4.4971e+2,1.0312e+4,4.3164e+4,5.4188e+3,1.3846e+3];
dc0=[1,8.6257e+1,2.9683e+3,4.8682e+2,1.0848e+2,4.5962];
lpshape(wl,bdb1,nL0,dL0,td,nc0,dc0);
qpause;
numC=nc0; denC=dc0;

% ANALYSIS
disp(' ')
disp('Analysis....')
disp(' ')

P=freqcp(nump,denp,wl,td);
G=freqcp(numC,denC,wl);

disp('chksiso(1,wl,W1,P,R,G); %margins spec')
drawnow
chksiso(1,wl,W1,P,R,G);
qpause; close(gcf);
