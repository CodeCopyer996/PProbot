function qftdm6d
% Fourth stage of QFTDM6
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P M A S w nm dm na da ns ds ...
       R W1 L bdb1 W3 H bdb3 ...
       ubdb ...
       wl nc0 dc0

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller');
set(info_str(2),'string','lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);');

% define a frequency array for loop shaping
wl = logspace(-3,3.3,100);

% obtain nominal plant from plant set
nL0=conv(nm,conv(na,conv(ns,nump(nompt,:))));
dL0=conv(dm,conv(da,conv(ds,denp(nompt,:))));

% no delay
del0=0;

% define initial controller
zc = [-2.6176e+001+ 3.2764e+001i
      -2.6176e+001- 3.2764e+001i
      -8.9383e+000+ 1.0620e+001i
      -8.9383e+000- 1.0620e+001i
      -3.7734e+002
      -1.4442e+002
      -7.0175e+001
      -6.1421e+000];
pc = [ 1.6848e+001
      -5.1293e+003+ 5.2329e+003i
      -5.1293e+003- 5.2329e+003i
      -1.2702e+003+ 1.6936e+003i
      -1.2702e+003- 1.6936e+003i
      -1.1330e+003
      -8.1836e+002+ 3.5211e+001i
      -8.1836e+002- 3.5211e+001i
      -3.8289e-001];
kc = 1.7204e+014;

[nc0,dc0] = zp2tf(zc,pc,kc);

lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);

% setup for call to next stage
qftexit('qftdm6e',info_btn);
