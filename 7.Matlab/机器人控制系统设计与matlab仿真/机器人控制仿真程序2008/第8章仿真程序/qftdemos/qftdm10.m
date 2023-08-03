function qftdm10
%
% QFT DEMO #10
%

% Yossi Chait
% 2/15/92
%
% Craig Borghesani
% 9/9/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nom ...
       nump denp P w td

% Setup for display of information
qft_val = 10;
qftstrt1

clc
disp(' Example #10 (inverted pendulum) describes the application of QFT to a')
disp(' feedback design problem with a parametrically uncertain flexible')
disp(' mechanical system with both open-loop instability and pure time delay.')
disp(' ')
disp(' Please refer to manual for more details....')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  Consider a continuous-time, siso, negative unity feedback system')
disp(' ')
disp('                                   |V(s)            |D(s)')
disp('                         ----      |      ----      |')
disp('             ---->x---->|G(s)|---->x---->|P(s)|---->x---->')
disp('             R(s) |      ----             ----        | Y(s)')
disp('                  |               --                  |')
disp('                  ---------------|-1|------------------')
disp('                                  --')
disp(' ')
disp('       The plant P(s) (motor current to pendulum angle)')
disp('       has a parametric uncertainty model:')
disp('          |    K*a             wn^2       s^2                   |')
disp('  P(s)  = {------------ ----------------- -------  exp^(-s*tau) }')
disp('          |s(s+a)-K*k*a s^2+2*z*wn*s+wn^2 L*s^2-g               |')
disp(' ')
disp('       L in [0.35,0.45] m, K in [1.5,1.7] m/v/s, a in [15,17]')
disp('       wn in [50,70] r/s, z in [0.01,0.02], tau=0.014 s')
disp('       g=9.81 m/s^2, k=11 v/m')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: design a controller')
disp('  G(s) such that it achieves')
disp(' ')
disp('  1) Robust stability')
disp(' ')
disp('  2) Robust margins (via closed-loop magnitude peaks)')
disp('         | P(jw)G(jw) |')
disp('         |------------| < 2.1,  w>0')
disp('         |1+P(jw)G(jw)|')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup for beginning of presentation format
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 10: Inverted Pendulum');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%===========================

set(info_str(1),'string','Computing plant templates...');
set(info_str(2),'string','(32 cases at 16 frequencies)');

% Computing plant templates
ll=[.3 .45];
kk=[1.5 1.7];
aa=[15 17];
ww=[50 70];
xx=[.01 .02];
kpf=.1;
g=9.8;

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

% Compute frequency responses
w=[0.1 0.2 0.5 1 2 5 10 30 35 40 42 47 49 50 60 70];
% time delay
td=.014;
P=freqcp(nump,denp,w,td);

% plot several templates
wb=[1 10 42 47 49 50 60 70];
plottmpl(w,wb,P,nom),title('Plant Templates');

% End of computations for stage 1

% Setup call to next stage of presentation
next_stage='qftdm10b';
last=0;
nxtstage
