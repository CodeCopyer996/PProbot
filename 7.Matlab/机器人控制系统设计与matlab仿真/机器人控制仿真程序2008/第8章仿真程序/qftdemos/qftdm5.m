function qftdm5
%
% QFT DEMO #5
%

% Yossi Chait
% 2/15/92
%
% Craig Borghesani
% 9/9/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w

% Setup for display of information
qft_val = 5;
qftstrt1

clc
disp(' Example #5 (ACC benchmark) describes the application of QFT to a')
disp(' feedback design problem with an ideal parametric uncertain flexible')
disp(' mechanical system.')
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
disp('       The plant model P(s) a parametric uncertainty model:')
disp('          |            k                                        |')
disp('        P(s) = { -------------------------- :  m1=m2=1; k in [0.5,2] }')
disp('          | m1*s^2 (m2*s^2+(1+m2/m1)k)                          |')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: design a controller')
disp('  G(s) such that it achieves')
disp(' ')
disp('  1) Robust stability')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup for beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 5: ACC Benchmark');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Computing plant templates...');
set(info_str(2),'string','(40 plants at 8 frequencies)');

% compute plant templates
k=logspace(log10(0.5),log10(2),39); % discretize uncertain parameter

c=1;
for j=k,
 nump(c,:)=j;denp(c,:)=conv([1,0],conv([1,0],[1,0,2*j]));  c=c+1;
end

% Compute frequency response
w=[0.01,0.1,0.9,0.99,1.01,1.5,2.01,20];
P=freqcp(nump,denp,w);

% plot templates
wb=w;
plottmpl(w,wb,P);
title('Plant Templates');

% End of computations for stage 1
next_stage = 'qftdm5b';
last=0;
nxtstage
