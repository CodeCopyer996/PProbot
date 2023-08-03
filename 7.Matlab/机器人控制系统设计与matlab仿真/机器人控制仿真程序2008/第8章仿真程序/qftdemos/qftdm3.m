function qftdm3
%
% QFT DEMO #3
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
       nump denp P w W1 bdb1 W2 bdb2

% Setup for display of information
qft_val = 3;
qftstrt1

clc
disp(' Example #3 (non-parametric uncertainty) describes the application of')
disp(' QFT to a feedback design problem with a non-parametrically uncertain')
disp(' plant and several robust performance specifications.')
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
disp('       The plant P(s) has a non-parametric uncertainty model:')
disp('             |   10                   delta(s) stable                |')
disp('      P(s) = {--------- (1+delta(s)): |delta(jw)|<a(w)               }')
disp('             |s(0.1s+1)               a(w)=.9(jw/.91+1)/((jw/1.001+1)|')
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
disp('         |------------| < 1.2,  w>0')
disp('         |1+P(jw)G(jw)|')
disp(' ')
disp('  3) Robust sensitivity reduction')
disp('         |     1      |')
disp('         |------------| < 0.089w^2,  w<5')
disp('         |1+P(jw)G(jw)|')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup for beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 3: Non-Parametric Uncertainty');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Computing nominal plant response');
set(info_str(2),'string','Plotting of templates not necessary');
pause(3);

% plant templates
nump=10;
denp=conv([1,0],[.1,1]); % nominal plant
w = [0.05,0.5,2,5,90];
P=freqcp(nump,denp,w);

% PLOT SEVERAL TEMPLATES
% No need here

% SOLVING FOR QFT BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,wbd1,W1,P,R);');

% compute bounds at all frequencies in w
wbd1 = w;

% define weight
W1 = 1.2;

% magnitude of uncertainty circle
R = freqcp(.9*[1/.91,1],[1/1.001,1],w);
R = abs(R);

% compute bounds
bdb1 = sisobnds(1,w,wbd1,W1,P,R);

% plot bounds
plotbnds(bdb1,[],[],win1_loc);
title('Robust Stability Bounds');
drawnow

% display info in information window
set(info_str(2),'string','bdb2=sisobnds(2,w,wbd2,W2,P,R)');

% the frequency array
wbd2=[0.05,0.5,2,5];

% compute specification
W2=freqcp(0.089*[1,0,0],1,w); % weight computed at w
W2=abs(W2);

% compute bounds
bdb2 = sisobnds(2,w,wbd2,W2,P,R);

% plot bounds
plotbnds(bdb2,[],[],win3_loc);
title('Robust Sensitivity Bounds');
drawnow

% End of computations for stage 1
next_stage = 'qftdm3b';
last=1;
nxtstage
