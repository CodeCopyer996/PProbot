function qftdm14
%
% QFT DEMO #14
%

% Yossi Chait
% 2/15/92
%
% Craig Borghesani
% 9/9/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.7 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       P P0 wp in bdb1 bdb2 phs W2

% Setup for display of information
qft_val = 14;
qftstrt1

clc
disp(' Example #14 (compact disk) describes the application of QFT to a')
disp(' high performance feedback design problem with a nonminimum phase')
disp(' zero and an experimental plant model including parametric uncertainty.')
disp(' ')
disp(' Please refer to manual for more details....')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  Consider a continuous-time (plant, zero-order-hold, sampling and')
disp('       computational delay all lumped together), siso,')
disp('       negative unity feedback system')
disp(' ')
disp('                   E(s)  ----             ----')
disp('             ---->x---->|G(s)|---------->|P(s)|---------->')
disp('             R(s) |      ----             ----        | Y(s)')
disp('                  |               --                  |')
disp('                  ---------------|-1|------------------')
disp('                                  --')
disp(' ')
disp('       The plant P(s) model is not known, however, a nominal frequency')
disp('       response has been obtained experimentally.  The three significant')
disp('       natural frequencies are allowed to vary by 5% from nominal values.')
disp('       The computed (w/o identification) uncertain frequency response')
disp('       model is')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 14: CD Mechanism - sampled-data');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

set(info_str(1),'string','Loading data from mat-file');
load sisocd

% define frequency array for computing plant templates
% define frequency array for computing plant templates
in=[25,81,113,132,154,187,241];
nompt = 63;

% plotting min and max of 125 cases
set(info_str(1),'string','Plotting min and max response of 125 cases...');

f = colordef('new','none');
set(f,'numbertitle','off','name','Frequency Response Set','vis','on','tag','qft');
subplot(211),loglog(wp,min(abs(P)),wp,max(abs(P)))
title('Magnitude')
subplot(212),semilogx(wp,180/pi*min(qatan4(P)),wp,180/pi*max(qatan4(P)))
title('Phase')

% End of computations for stage 1

next_stage = 'qftdm14b';
last=2;
nxtstage
