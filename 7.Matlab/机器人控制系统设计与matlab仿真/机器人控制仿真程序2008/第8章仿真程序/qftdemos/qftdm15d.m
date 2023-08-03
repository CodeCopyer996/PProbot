function qftdm15d
% Fourth stage of QFTDM15
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump11 nump12 nump21 nump22 denp nom w ...
       P11 P12 P21 P22 W11 W12 W21 W22 bdb1 ubdb1 ...
       wl nc0 dc0 aa ...
       ubdb2 nc1 dc1

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Designing G2 with LPSHAPE...');
set(info_str(2),'string','lpshape(wl,ubdb2,nL0,dL0,del0,nc0,dc0);');
drawnow

wl = logspace(-2,3,200);  % define a frequency array for loop shaping

% nominal loop
nL0=freqcp(nump22(nom,:),denp(nom,:),wl)-freqcp(nump12(nom,:),denp(nom,:),wl).*...
    freqcp(nump21(nom,:),denp(nom,:),wl)./(1./freqcp(nc1,dc1,wl)+...
    freqcp(nump11(nom,:),denp(nom,:),wl));
dL0=[];

% initial controller
nc0=6.086878e+5 *[1,173.4,1.36108e+4,2.75809e+4,1.1270886e+5];
dc0=[1,718.65,1.785867e+5,1.6925058e+7,4.165129287e+8,0];

lpshape(wl,ubdb2,nL0,dL0,[],nc0,dc0);

% setup for call to next stage
qftexit('qftdm15e',info_btn);
