function qftdm4
%
% QFT DEMO #4
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
       nump denp P w W1 bdb1 W6 bdb6

% Setup for display of information
qft_val = 4;
qftstrt1

clc
disp(' Example #4 (classical design) describes the application of QFT to a')
disp(' feedback design problem with a fixed plant and both gain margin')
disp(' and bandwidth specifications.')
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
disp('       The plant model P(s) is fixed:')
disp('               10')
disp('      P(s) = ------')
disp('             s(s+1)')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: design a controller')
disp('  G(s) such that it achieves')
disp(' ')
disp('  1) Stability')
disp(' ')
disp('  2) Gain margin of 1.8')
disp(' ')
disp('  3) Zero steady state error for velocity reference commands')
disp(' ')
disp('  4) Bandwidth limitation')
disp('         | P(jw)G(jw) |')
disp('         |------------| < 0.707,  w>10')
disp('         |1+P(jw)G(jw)|')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup for beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 4: Design for fixed plant');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Fixed plant');
set(info_str(2),'string','Plotting of templates not necessary');
pause(2);

%define fixed plant
nump = 10;
denp = [1,1,0];

% Compute frequency response
w = [10,100];
P=freqcp(nump,denp,w);

% BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,P);');

% compute bounds at selected frequencies in w
wbd1 = [100];

% define specification
W1 = 1.2;

% compute bounds
bdb1 = sisobnds(1,w,wbd1,W1,P);

% plot bounds
plotbnds(bdb1,[],[],win1_loc);
title('Robust Stability Bound');
drawnow;

% display info in information window
set(info_str(2),'string','bdb6=sisobnds(6,w,wbd6,W6,P)');

% the frequency array
wbd6=10;

% define specification
W6=0.707;

% compute bounds
bdb6 = sisobnds(6,w,wbd6,W6,P);

% plot bounds
plotbnds(bdb6,[],[],win3_loc);
title('Bandwidth Bound');
drawnow;

% End of computations for stage 1
next_stage = 'qftdm4b';
last=1;
nxtstage
