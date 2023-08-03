function qftdm11
%
% QFT DEMO #11
%

% Yossi Chait
% 2/15/92
%
% Craig Borghesani
% 9/9/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.7 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       lfrq mag phs P bdb1 W1 bdb2 W2

% Setup for display of information
qft_val = 11;
qftstrt1

clc
disp(' Example #11 (active vibration isolation) describes the application of')
disp(' QFT to a feedback design problem with an experimental plant model.')
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
disp('       The plant P(s) model (mount input to measured engin acceleration)')
disp('       is not known, however, an experimental frequency response is')
disp('       available')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 11: Active Vibration Isolation');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

set(info_str(1),'string','Loading data from mat-file');
load lorddata

% PLANT INFORMATION
frq1 = frf1(:,1);
mag1 = frf1(:,2);
phs1 = frf1(:,3);

frq2 = frf2(:,1);
mag2 = frf2(:,2);
phs2 = frf2(:,3);

fmin = 30;
fmid = 1000;
fmax = 6000;

s1 = find(frq1==fmid);
if isempty(s1), s1=1; end
s1 = s1 + 1;
e1 = find(frq1==fmax);
if isempty(e1), e1=max(size(frq1)); end

s2 = find(frq2==fmin);
if isempty(s2), s2=1; end
e2 = find(frq2==fmid);
if isempty(e2), e2=max(size(frq2)); end

lfrq = [frq2(s2:e2);frq1(s1:e1)];
mag = [mag2(s2:e2);mag1(s1:e1)];
phso = [phs2(s2:e2);phs1(s1:e1)];
phs = (180/pi)*unwrap((pi/180)*phso);

% plot the experimental transfer function
set(info_str(1),'string','Plotting experimental transfer function');
f = colordef('new','none');
set(f,'name','Experimental Transfer Function','numbertitle','off','vis','on','tag','qft');
subplot(211)
semilogx(lfrq,mag), grid
title('Measured Frequency Response')
subplot(212)
semilogx(lfrq,phs), grid

% End of computations for stage 1

next_stage = 'qftdm11b';
last=2;
nxtstage
