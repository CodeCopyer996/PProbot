function qftdm13e
% Fifth stage of QFTDM13
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump denp P w T ...
       W1 bdb1 wbd7 W7 bdb7 ...
       ubdb ...
       wl nc0 dc0 ...
       nf0 df0

% clear strings in information window
set(info_str,'string','');

% PRE-FILTER DESIGN
%=================================

set(info_str(1),'string','Initiating DPFSHAPE with pre-designed pre-filter...');
set(info_str(2),'string','dpfshape(T,7,w,wbd7,W7,P,[],G,[],nf0,df0);');

numc=nc0; denc=dc0;

G=dfreqcp(T,numc,denc,w);

% define initial filter
% note: since T is very small we can take the Z transform of the analog pre-filter!
nf0=0.2489027e-4*[1,0];
df0=[1,-1.9912137,0.9912386];

% initiate shape environment
dpfshape(T,7,w,wbd7,W7,P,[],G,[],nf0,df0);

% setup for call to next stage when shaping completed
qftexit('qftdm13f',info_btn);
