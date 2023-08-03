function qftdm7
%
% QFT DEMO #7
%

% Yossi Chait
% 5/5/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump2 denp2 R P2 w

% Setup for display of information
qft_val = 7;
qftstrt1

clc
disp(' Example #7 (inner-outer cascaded loop) describes the application of QFT')
disp(' to a cascaded-loop robust feedback design problem using a sequential')
disp(' design of the inner-loop followed by the outer-loop.  When compared to')
disp(' Example 1, it illustrates the advantage of cascaded-loop design over')
disp(' single-loop design in terms of reduced control bandwidth.')
disp(' ')
disp(' Please refer to manual for more details....')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  Consider a continuous-time, siso, negative unity feedback system')
disp(' ')
disp('                                       |V(s)                     |D(s)')
disp('                 -----        ------   |   -----        -----    |')
disp('       ---->x-->|G1(s)|-->x--|G2(s)|-->x--|P2(s)|-->x--|P1(s)|-->x--->')
disp('       R(s) |    -----    |   -----        -----    |   -----    |Y(s)')
disp('            |             |       --                |            |')
disp('            |             -------|-1|---------------x<--         |')
disp('            |         --          --                  N2(s)      | N1(s)')
disp('            ---------|-1|----------------------------------------x<--')
disp('                      --')
disp(' ')
disp('       The plant P1(s) and P2(s) have parametric uncertainty models:')
disp('             |      1                                   |')
disp('     P1(s) = { ----------- :   a in [1,5], b in [20,30] }')
disp('             | (s+a) (s+b)                              |')
disp(' ')
disp('          P2(s) = {k: k in [1,10]}')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: design the controllers')
disp('  G1(s) and G2(s) such that they achieve')
disp(' ')
disp('  1) Robust stability')
disp(' ')
disp('  2) Robust margins: 50 degrees phase margin in each loop')
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
disp(' Strike any key to continue')
pause
clc

% Setup for beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 7: Cascaded Inner-Outer');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Closing inner loop first...');
set(info_str(2),'string','Computing inner plant templates (5 points)');

% CLOSING INNER LOOP FIRST

% define radius
R = 0;

% compute the boundary of the plant templates
c=1;
for k = logspace(log10(1),log10(10),5),
 nump2(c,:) = k;  denp2(c,:) = 1;  c = c + 1;
end

% define nominal plant case
nompt = 1;

% Compute frequency response
w = [.1,1,5,10,50,500];
P2=freqcp(nump2,denp2,w);


% plotting several templates
plottmpl(w,w,P2,nompt);
title('Plant Templates');

% End of computations for stage 1
next_stage = 'qftdm7b';
last=0;
nxtstage
