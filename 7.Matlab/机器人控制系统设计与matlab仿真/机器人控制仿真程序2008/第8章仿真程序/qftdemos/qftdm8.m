function qftdm8
%
% QFT DEMO #8
%

% Yossi Chait
% 5.5.94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump1 denp1 P1 w nump2 denp2 P2

% Setup for display of information
qft_val = 8;
qftstrt1

clc
disp(' Example #8 (outer-inner cascaded loop) describes the application')
disp(' of QFT to a cascaded-loop robust feedback design problem using a')
disp(' a sequential design of the outer-loop followed by the inner-loop.')
disp(' When compared to inner-outer design (Example 7), it illustrates')
disp(' the possible advantage of an improved control bandwidth distribution')
disp(' between the two loops (via the concept of "free uncertainty").')
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
disp('     P2(s) = {k: k in [1,10]}')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: design the controllers')
disp('  G1(s) and G2(s) such that they achieve')
disp(' ')
disp('   1) Robust stability')
disp(' ')
disp('   2) Robust margins: 50 degrees phase margin in each loop')
disp(' ')
disp('   3) Robust output disturbance rejection')
disp('         |Y(jw)|       |(jw)^3+64(jw)^2+748(jw)+2400|')
disp('         |-----| < 0.02|----------------------------|, w<10')
disp('         |D(jw)|       |    (jw)^2+14.4(jw)+169     |')
disp(' ')
disp('   4) Robust input disturbance rejection')
disp('         |Y(jw)|')
disp('         |-----| < 0.01, w<50')
disp('         |V(jw)|')
disp('')
disp(' Strike any key to continue')
pause
clc

% Setup for beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 8: Cascaded Outer-Inner');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

% outer loop tf
% compute the boundary of the plant templates

% display information string in information window
set(info_str(1),'string','Computing outer plant (14 points)...');
pause(2);

aa = logspace(log10(1),log10(5),5);
bb = logspace(log10(20),log10(30),3);
c = 1; b = bb(1);
for a = aa,
  nump1(c,:) = 1;  denp1(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = bb(3);
for a = aa,
 nump1(c,:) = 1;  denp1(c,:) = [1,a+b,a*b];  c = c + 1;
end
a = aa(1);
for b = bb(2:3),
 nump1(c,:) = 1;  denp1(c,:) = [1,a+b,a*b];  c = c + 1;
end
a = aa(5);
for b = bb(2:3),
 nump1(c,:) = 1;  denp1(c,:) = [1,a+b,a*b];  c = c + 1;
end
%
nompt = 1;  % define nominal plant case
w = [.1,1,5,10,15,25,50,500];
P1=freqcp(nump1,denp1,w);
nompt=1;

% TEMPLATES
plottmpl(w,w,P1,nompt,win1_loc);
title('Outer Plant Templates');

% inner loop tf
% compute the boundary of the plant templates
set(info_str(1),'string','Computing inner plant templates (3 points)...');
pause(2);

c=1;
for k = logspace(log10(1),log10(10),5),
 nump2(c,:) = k;  denp2(c,:) = 1;  c = c + 1;
end

% compute P2 responses
P2=freqcp(nump2,denp2,w);
nompt = 1;  % define nominal plant case

% TEMPLATES
plottmpl(w,w,P2,nompt,win3_loc);
title('Inner Plant Templates');

% End of computations for stage 1
next_stage = 'qftdm8b';
last=0;
nxtstage
