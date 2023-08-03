function qftdm9
%
% QFT DEMO #9
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
       nump denp P w

% Setup for display of information
qft_val = 9;
qftstrt1

clc
disp(' Example #9 (flexible servomechanism) describes the application of QFT')
disp(' to a feedback design problem with a parametrically uncertain flexible')
disp(' mechanical system and several robust performance specifications.')
disp(' ');
disp(' Please refer to manual for more details....')
disp(' ');
disp(' Strike any key to continue')
pause
clc

disp('  Consider a continuous-time, siso feedback system')
disp(' ');
disp('          U(s) --             --  V(s)')
disp('          <---|Wu|<--|   |<--|Wv|<---')
disp('               --    |   |    --')
disp('                     |   |           ----       ----')
disp('          ----->x--->x-->x----------|G(s)|----->|P(s)|---->x---->')
disp('          R(s)  |                    ----       ----       | Y(s)')
disp('                |             --                           |')
disp('                -------------|-1|--------------------------x<--|Wu|<--')
disp('                              --                                    N(s)')
disp(' ');
disp('       The plant P(s) has a parametric uncertainty model:')
disp('             |         b1*s+b2           a1,a2,a3,a4,b1 and b2   |')
disp('     P(s)  = { --------------------- :   functions of c          }')
disp('             | a1*s^3+a2*s^2+a3*s+a4     c in [0.0111,0.0195] N/m|')
disp(' ');
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: design a controller')
disp('  G(s) such that it achieves')
disp(' ');
disp('  1) Robust stability')
disp(' ');
disp('  2) Robust margins (via closed-loop magnitude peaks)')
disp('         | P(jw)G(jw) |')
disp('         |------------| < 1.1')
disp('         |1+P(jw)G(jw)|')
disp(' ');
disp('  3) Robust tracking')
disp('         |     R(jw)-Y(jw)|')
disp('         |W(w) -----------| < 1')
disp('         |        R(jw)   |')
disp(' ');
disp('  4) Robust disturbance rejection')
disp('         |     R(jw(-Y(jw)|')
disp('         |W(w) -----------| < 1')
disp('         |        V(jw)   |')
disp(' ');
disp(' Strike any key to continue')
pause
clc

disp('  5) Robust noise rejection')
disp('         |     R(jw)-Y(jw)|          |     U(jw)|')
disp('         |W(w) -----------| < 1,     |W(w) -----| < 1')
disp('         |        N(jw)   |          |     N(jw)|')
disp(' ');
disp('  6) Robust control effort limitation')
disp('         |U(jw)|        |U(jw)|')
disp('         |-----| < 1,   |-----| < 1')
disp('         |R(jw)|        |V(jw)|')
disp(' ');
disp('  7) <100hz control terms bandwidth (DSP board limitation)')
disp(' ');
disp('       where')
disp('                |2*pi*wb|')
disp('         W(w) = |-------|, wb=10hz (bandwidth),')
disp('                |  jw+1 |')
disp(' ');
disp('         wn = 0.01,   wu = 0.33,    wv = 0.1')
disp(' ');
disp(' Strike any key to continue')
pause
clc

% Setup for beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 9: Uncertain Flexible Mechanism');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Computing plant templates...');
set(info_str(2),'string','(plotting only at selected frequencies)');

% computing plant templates
% system constants
j1=1.45e-6;j2=j1;km=34.5e-2;ds=5e-6;dm1=.45e-6;dm2=dm1;
kgen=.05;kt=.1333/10;ka=20;
% discretize uncertain parameter
cs=(1.11:.04:1.95)/100;
j=1;
for k=cs,
 nump(j,:)=(kgen*kt*ka)*km*[ds k];
 denp(j,:)=[j1*j1,j1*(ds+dm1)+j2*(ds+dm1),k*(j1+j2)+dm1*dm2,k*(dm1+dm2)];
 j=j+1;
end

% define nominal plant case
nompt = 22;

% Compute frequency response
w=[.1,1,10,50,140,155,164,180,500];
P=freqcp(nump,denp,w);

% plot several templates
wb=[.1,1,10,50,155,180,500];
plottmpl(w,wb,P,nompt);
title('Plant Templates');

% End of computations for stage 1
next_stage = 'qftdm9b';
last=0;
nxtstage
