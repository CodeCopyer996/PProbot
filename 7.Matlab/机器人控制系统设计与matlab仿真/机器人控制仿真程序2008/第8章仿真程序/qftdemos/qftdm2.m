function qftdm2
%
% QFT DEMO #2
%

% Yossi Chait
% 2/15/93
%
% Craig Borghesani
% 9/9/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump denp P w

qft_val = 2;

% Setup for text display in command window
qftstrt1

clc

disp(' Example #2 (2 DOF) describes the application of QFT to a 2')
disp(' degree-of-freedom feedback design problem with a parametrically')
disp(' uncertain plant and QFT tracking specification.')
disp(' ')
disp(' Please refer to manual for more details....')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  Consider a continuous-time, siso, negative unity feedback system')
disp(' ')
disp('                                       |V(s)            |D(s)')
disp('            ----             ----      |      ----      |')
disp('      ----->|F(s)|--->x---->|G(s)|---->x---->|P(s)|---->x---->')
disp('      R(s)  ----      |      ----             ----      | Y(s)')
disp('                      |             --                  |')
disp('                      -------------|-1|------------------')
disp('                                    --')
disp(' ')
disp('       The plant P(s) has a parametric uncertainty model:')
disp('              |    k                                |')
disp('      P(s)  = { ------- :  k in [1,10], a in [1,10] }')
disp('              | s (s+a)                             |')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: design a controller')
disp('  G(s) and a pre-filter F(s) such that they achieve')
disp(' ')
disp('  1) Robust stability')
disp(' ')
disp('  2) Robust margins (via closed-loop magnitude peaks)')
disp('         | P(jw)G(jw) |')
disp('         |------------| < 1.2,  w>0')
disp('         |1+P(jw)G(jw)|')
disp(' ')
disp('  3) Robust tracking (related to tracking step responses)')
disp('                |       P(jw)G(jw) |')
disp('         a(w) < |F(jw) ------------| < b(w),  w<10')
disp('                |      1+P(jw)G(jw)|')
disp(' ')
disp('                |           120              |')
disp('         a(w) = |----------------------------|')
disp('                |(jw)^3+17(jw)^2+828(jw)+120 |')
disp(' ')
disp('                |  0.6584(jw+30)    |')
disp('         b(w) = |-------------------|')
disp('                |(jw)^2+4(jw)+19.752|')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup information window
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 2: QFT Tracking');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

set(info_str(1),'string','Computing plant templates...');

% computing the boundary of plant templates
c = 1;	a = 1;
for k = [1,2.5,6,10],
	nump(c,:) = k*a; denp(c,:) = [1,a,0]; 	c = c + 1;
end
a = 10;
for k = [1,2.5,6,10],
	nump(c,:) = k*a; denp(c,:) = [1,a,0];	c = c + 1;
end
k = 1;
for a = [1.5,3,6],
	nump(c,:) = k*a; denp(c,:) = [1,a,0];	c = c + 1;
end
k = 10;
for a = [1.5,3,6],
	nump(c,:) = k*a; denp(c,:) = [1,a,0];	c = c + 1;
end

% Compute frequency response
w=[.1,.5,1,2,15,100];
P=freqcp(nump,denp,w);

% plot templates
plottmpl(w,w,P);
title('Plant Templates');

% End of computations for stage 1
next_stage = 'qftdm2b';
last=0;
nxtstage
