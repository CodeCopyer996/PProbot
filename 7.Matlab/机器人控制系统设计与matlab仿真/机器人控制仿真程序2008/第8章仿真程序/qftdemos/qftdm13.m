function qftdm13
%
% QFT DEMO #13
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
       nump denp P w T

% Setup for display of information
qft_val = 13;
qftstrt1

clc
disp(' Example #13 (2 DOF) describes the application of QFT to a 2')
disp(' degree-of-freedom, discrete-time, feedback design problem with a')
disp(' parametrically uncertain plant and QFT tracking specification.')
disp(' ')
disp(' Please refer to manual for more details....')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  Consider a discrete-time, siso, negative unity feedback system')
disp(' ')
disp('                                       |V(s)            |D(s)')
disp('            ----             ----      |      ----      |')
disp('      ----->|F(s)|--->x---->|G(s)|---->x---->|P(s)|---->x---->')
disp('      R(s)  ----      |      ----             ----      | Y(s)')
disp('                      |             --                  |')
disp('                      -------------|-1|------------------')
disp('                                    --')
disp(' ')
disp('       The plant P(z) has parametric a uncertainty model:')
disp('          P(z)= Z(zoh(s)*P(s))')
disp('          Z(.) = Z-transform')
disp('          zoh(s) = zero-order hold')
disp('              |    k                                |')
disp('     P(s)  = { ------- :  k in [1,10], a in [1,10] }')
disp('              | s (s+a)                             |')
disp(' ')
disp(' Strike any key to continue')
pause
clc

disp('  The performance specifications are: given a sampling time')
disp('       of T=0.001 sec design a controller')
disp('       G(z) and a pre-filter F(z) such that they achieve')
disp(' ')
disp('  1) Robust stability')
disp(' ')
disp('  2) Robust margins (via closed-loop magnitude peaks)')
disp('         | P(jw)G(jw) |')
disp('         |------------| < 1.2,  z=exp^(i*w*T), w>0')
disp('         |1+P(jw)G(jw)|')
disp(' ')
disp('  3) Robust tracking (related to tracking step responses)')
disp('                |       P(jw)G(jw) |')
disp('         a(w) < |F(jw) ------------| < b(w),  z=exp^(i*w*T), w<10')
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

% Setup beginning of presentation
qftstrt2

% display information string in information window
set(info_str(1),'string','QFT DEMO 13: QFT Tracking - Discrete-time');
set(info_str(2),'string','Please refer to manual for details...');
set(info_win,'vis','on');
pause(3);
set(info_str,'string','');

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Computing plant templates...');

% define sampling time
T=0.001;

% computing the boundary of plant templates
nump =                  [0    4.998333749117734e-007    4.996667917200881e-007
                         0    1.249583437390456e-006    1.249166979189198e-006
                         0    2.499166875002956e-006    2.498333958156352e-006
                         0    3.748750312393412e-006    3.747500937345549e-006
                         0    4.998333749783868e-006    4.996667916423725e-006
                         0    4.983374916944783e-006    4.966791333993470e-006
                         0    1.245843729202889e-005    1.241697833509470e-005
                         0    2.491687458405778e-005    2.483395667007837e-005
                         0    3.737531187608667e-005    3.725093500517307e-005
                         0    4.983374916789352e-005    4.966791334037879e-005
                         0    9.993336664848584e-007    9.986676662299132e-007
                         0    2.246628793445282e-006    2.243261376988492e-006
                         0    4.486530320368942e-006    4.473090906786936e-006
                         0    9.993336665292674e-006    9.986676661410954e-006
                         0    2.246628793467487e-005    2.243261376966288e-005
                         0    4.486530320413351e-005    4.473090906698119e-005];

denp =[1.000000000000000e+000   -1.999000499833375e+000    9.990004998333750e-001
    1.000000000000000e+000   -1.999000499833375e+000    9.990004998333750e-001
    1.000000000000000e+000   -1.999000499833375e+000    9.990004998333750e-001
    1.000000000000000e+000   -1.999000499833375e+000    9.990004998333750e-001
    1.000000000000000e+000   -1.999000499833375e+000    9.990004998333750e-001
    1.000000000000000e+000   -1.990049833749168e+000    9.900498337491682e-001
    1.000000000000000e+000   -1.990049833749168e+000    9.900498337491682e-001
    1.000000000000000e+000   -1.990049833749168e+000    9.900498337491682e-001
    1.000000000000000e+000   -1.990049833749168e+000    9.900498337491682e-001
    1.000000000000000e+000   -1.990049833749168e+000    9.900498337491682e-001
    1.000000000000000e+000   -1.998001998667333e+000    9.980019986673330e-001
    1.000000000000000e+000   -1.995510109829571e+000    9.955101098295704e-001
    1.000000000000000e+000   -1.991040378772884e+000    9.910403787728836e-001
    1.000000000000000e+000   -1.998001998667333e+000    9.980019986673330e-001
    1.000000000000000e+000   -1.995510109829571e+000    9.955101098295704e-001
    1.000000000000000e+000   -1.991040378772884e+000    9.910403787728836e-001];

% Compute ahead magnitudes and phase (speed up computations)
w=[.1,.5,1,2,15,100,1000,pi/T];
P=dfreqcp(T,nump,denp,w);

% PLOT SEVERAL TEMPLATES
plottmpl(w,w,P);
title('Plant Templates');

% End of computations for stage 1

next_stage = 'qftdm13b';
last=0;
nxtstage
