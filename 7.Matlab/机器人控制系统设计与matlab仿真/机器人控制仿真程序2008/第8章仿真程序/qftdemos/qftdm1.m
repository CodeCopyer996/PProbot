function qftdm1
% QFT DEMO #1  (main example)

% Craig Borghesani
% 9/9/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w

% Setup for display of information
qft_val = 1;
qftstrt1

clc
disp(' Example #1 (main example) is used in the manual to describe in great')
disp(' detail the application of QFT (including use of relevant toolbox functions)')
disp(' to a feedback design problem with a parametrically uncertain plant and')
disp(' several robust performance specifications.')
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
disp('       The plant P(s) has a parametric uncertainty model:')
disp('             |      k                                   |')
disp('     P(s)  = { ----------- :    k in [1,10], a in [1,5] }')
disp('             | (s+a) (s+b)      b in [20,30]            |')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: design a controller')
disp('       G(s) such that it achieves')
disp(' ')
disp('  1) Robust stability')
disp(' ')
disp('  2) Robust margins (via closed-loop magnitude peaks)')
disp('         | P(jw)G(jw) |')
disp('         |------------| < 1.2,  w>0')
disp('         |1+P(jw)G(jw)|')
disp(' ')
disp('  3) Robust output disturbance rejection')
disp('         |Y(jw)|       |(jw)^3+64(jw)^2+748(jw)+2400|')
disp('         |-----| < 0.02|----------------------------|, w<10')
disp('         |D(jw)|       |    (jw)^2+14.4(jw)+169     |')
disp(' ')
disp('  4) Robust input disturbance rejection')
disp('         |Y(jw)|')
disp('         |-----| < 0.01, w<50')
disp('         |V(jw)|')
disp(' ')
disp('Strike any key to continue')
pause;

% Setup for beginning of presentation format
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 1: Main Example');
set(info_str(2),'string','Please refer to manual for further details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%========================

set(info_str(1),'string','Computing plant templates');
set(info_str(2),'string','');

% compute the boundary of the plant templates
c = 1;
k = 10; b = 20;
c = 1; k = 10; b = 20;
for a = logspace(log10(1),log10(5),10),
 nump(c,:) = k;  denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
k = 1; b = 30;
for a = logspace(log10(1),log10(5),10),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = 30; a = 5;
for k = logspace(log10(1),log10(10),10),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = 20; a = 1;
for k = logspace(log10(1),log10(10),10),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end

% define nominal plant case
nompt = 21;

% Compute responses
w = [.1,5,10,100];
P=freqcp(nump,denp,w);

% TEMPLATES
plottmpl(w,w,P,nompt);
title('Plant Templates');

% End of computations for stage 1

% Setup call to next stage of presentation
next_stage='qftdm1b';
last=0;
nxtstage
