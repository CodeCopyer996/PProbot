function qftdm9e
% Fifth stage of QFTDM9
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w ...
       R W1 bdb1 W2 bdb2 W4 bdb4 ...
       ubdb ...
       wl nc0 dc0 ...
       nf0 df0 G

set(info_str,'string','');

% PRE-FILTER DESIGN
%=================================

set(info_str(1),'string','Invoking PFSHAPE with pre-designed filter');
set(info_str(2),'string','pfshape(4,wl,wl,W4,P,[],G,1,nf0,df0);');

numc=nc0; denc=dc0;

% First compute ahead magnitudes and phase (speed up computations)
P=freqcp(nump,denp,wl);
G=freqcp(numc,denc,wl);

% define initial pre-filter
nf0=1;
df0=[1/477,1];

pfshape(4,wl,wl,W4,P,[],G,1,nf0,df0);

% setup for call to next stage
qftexit('qftdm9f',info_btn);
