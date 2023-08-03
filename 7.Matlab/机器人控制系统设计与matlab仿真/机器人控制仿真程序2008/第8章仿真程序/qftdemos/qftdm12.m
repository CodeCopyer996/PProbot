function qftdm12
%
% QFT DEMO #12
%

% Yossi Chait
% 2/15/92
%
% Craig Borghesani
% 9/9/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn T1 T2 T3

% Setup for display of information
qft_val = 12;
qftstrt1

clc
disp(' Example #12 (main example - discrete-time) is used in the manual')
disp(' to describe in great detail the application of QFT (including use')
disp(' of relevant toolbox functions) to a feedback design problem with')
disp(' parametrically uncertain plant and several robust performance')
disp(' specifications.')
disp(' ')
disp(' Please refer to manual for more details....')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  Consider a discrete-time, siso, negative unity feedback system')
disp(' ')
disp('                                   |V(z)            |D(z)')
disp('                         ----      |      ----      |')
disp('             ---->x---->|G(z)|---->x---->|P(z)|---->x---->')
disp('             R(z) |      ----             ----        | Y(z)')
disp('                  |               --                  |')
disp('                  ---------------|-1|------------------')
disp('                                  --')
disp(' ')
disp('       The plant P(z) has parametric a uncertainty model:')
disp('          P(z)= Z(zoh(s)*P(s))')
disp('          Z(.) = Z-transform')
disp('          zoh(s) = zero-order hold')
disp('             |      k                                   |')
disp('     P(s)  = { ----------- :    k in [1,10], a in [1,5] }')
disp('             | (s+a) (s+b)      b in [20,30]            |')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: gievn a choice of sampling')
disp('       time, T=0.001, 0.003 or 0.01 sec, design a controller')
disp('       G(z) such that it achieves')
disp(' ')
disp('  1) Robust stability')
disp(' ')
disp('  2) Robust margins (via closed-loop magnitude peaks)')
disp('         | P(z)G(z) |')
disp('         |------------| < 1.2,  z=exp^(i*w*T), w in [0,pi/T]')
disp('         |1+P(z)G(z)|')
disp(' ')
disp('  3) Robust output disturbance rejection')
disp('         |Y(z)|       |(jw)^3+64(jw)^2+748(jw)+2400|')
disp('         |----| < 0.02|----------------------------|, z=exp^(i*w*T), w<10')
disp('         |D(z)|       |    (jw)^2+14.4(jw)+169     |')
disp(' ')
disp('  4) Robust input disturbance rejection')
disp('         |Y(z)|')
disp('         |----| < 0.01, z=exp^(i*w*T), w<50')
disp('         |V(z)|')
disp(' ')
disp(' Strike any key to continue')
pause
clc

% Setup beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 12: Main Example - Discrete-Time');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
set(info_btn,'vis','off');
pause(3);
set(info_str,'string','');

set(info_str(1),'string','Three sampling times with controllers:');
T1=uicontrol(info_win,'style','push','units','norm','pos',[50,5,60,20].*info_scr,...
         'string','T=0.001','callback','qftdm12c(0.001)');
T2=uicontrol(info_win,'style','push','units','norm','pos',[145,5,60,20].*info_scr,...
         'string','T=0.003','callback','qftdm12c(0.003)');
T3=uicontrol(info_win,'style','push','units','norm','pos',[240,5,60,20].*info_scr,...
         'string','T=0.01','callback','qftdm12c(0.01)');
