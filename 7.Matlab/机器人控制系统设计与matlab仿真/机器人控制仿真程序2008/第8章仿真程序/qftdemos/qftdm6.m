function qftdm6
%
% QFT DEMO #6
%

% Yossi Chait
% 2/15/93
%
% Craig Borghesani
% 11/18/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P M A S w nm dm na da ns ds

% Setup of display of information
qft_val = 6;
qftstrt1

clc
disp(' Example #6 (missile) describes the application of QFT to a missile')
disp(' at different operating points in a flight envelop;  A plant model with')
disp(' both parametric and non-parametric uncertainty and different')
disp(' performance specifications at different operating points.')
disp(' ')
disp(' Please refer to manual for more details....')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  Consider a continuous-time, siso feedback system')
disp(' ')
disp('                                              |V(s)')
disp('                   ----    ----      ----     |      ----')
disp('        ----->x-->|G(s)|--|A(s)|----|M(s)|--->x---->|P(s)|---->x---->')
disp('        R(s)  |    ----    ----      ----            ----     | Y(s)')
disp('              |             -----                             |')
disp('              -------------|-D(s)|----------------------------')
disp('                            -----')
disp(' ')
disp('       The plant P(s), simplified dynamics evaluated at three points')
disp('       on the flight envelop, has a mixed parametric and non-parametric')
disp('       uncertainty model:')
disp('             |                                                         |')
disp('      P(s) = {P (s)(1+delta (s)): delta (s) stable, |delta (jw)|<r (w) }')
disp('             | i           i           i                  i       i    |')
disp(' where')
disp('                           a1*s+a2')
disp('      P (s) =  ---------------------')
disp('       i       b1*s^3+b2*s^2+b3*s+b4')
disp(' ')
disp('      i=1:  a1=335, a2=237, b1=20.7, b2=39, b3=257, b4=-9.5,  r=0.1')
disp('      i=2:  a1=315, a2=227, b1=19.7, b2=37, b3=247, b4=-9.0,  r=0.05')
disp('      i=3:  a1=345, a2=247, b1=23.7, b2=36, b3=267, b4=-10.5, r=0.075')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('       The amplifier A(s) is:')
disp('                     1')
disp('           A(s) = -------')
disp('                  0.01s+1')
disp(' ')
disp('       The servo motor M(s) is:')
disp('                            1')
disp('           M(s) = ----------------------')
disp('                  107(0.001s^2++0.13s+1)')
disp(' ')
disp('       The rate gyro nD(s) is:')
disp('                     27*40^2*s')
disp('         D(s) = ----------------')
disp('                s^2+1.2*40s+40^2')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications (reflecting different requirements')
disp('  at different operating points) are: design a controller')
disp('  G(s) such that it achieves')
disp(' ')
disp('  1) Robust stability')
disp(' ')
disp('  2) Robust margins (via closed-loop magnitude peaks)')
disp('         | P(jw)M(jw)A(jw)G(jw)D(jw) |             i=1: W1=1.3')
disp('         |---------------------------| < W1, w>0,  i=2: W1=1.2')
disp('         |1+P(jw)M(jw)A(jw)G(jw)D(jw)|             i=3: W1=1.25')
disp(' ')
disp('  3) Robust input disturbance rejection')
disp('         |Y(jw)|                    i=1: W2=0.04')
disp('         |-----| < W2, w in [1,8],  i=2: W2=0.036')
disp('         |V(jw)|                    i=3: W2=0.038')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 6: Missle');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Computing plant templates...');

% compute parametric plant templates
a1 = 335; a2 = 237; b1 = 20.7; b2 = 39; b3 = 257; b4 = -9.5;
nump(1,:) = [a1,a2];   denp(1,:) = [b1,b2,b3,b4];
a1 = 315; a2 = 227; b1 = 19.7; b2 = 37; b3 = 247; b4 = -9.0;
nump(2,:) = [a1,a2];   denp(2,:) = [b1,b2,b3,b4];
a1 = 345; a2 = 247; b1 = 23.7; b2 = 36; b3 = 267; b4 = -10.5;
nump(3,:) = [a1,a2];   denp(3,:) = [b1,b2,b3,b4];

% define nominal plant case
nompt = 1;

%servomotor
nm = 1/107; dm = [0.001,0.13,1];

%amplifier
na = 1; da = [0.01,1];

%rate sensor
ns = 27*[1,0]; ds = [1/40^2,1.2/40,1];

% Compute frequency response
w = [1,3,5,10,30];
P=freqcp(nump,denp,w);
M=freqcp(nm,dm,w);
A=freqcp(na,da,w);
S=freqcp(ns,ds,w);

% plot several templates
plottmpl(w,w,P,nompt);
title('Plant Templates (parametric part w/o hardware)');

% End of computations for stage 1

next_stage = 'qftdm6b';
last=0;
nxtstage
