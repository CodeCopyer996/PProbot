function qftdm2e
% Fifth stage of QFTDM2
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump denp P w ...
       bdb1 bdb7 W1 W7 wbd7 ...
       ubdb ...
       nc0 dc0 ...
       nf0 df0 G

% clear strings in information window
set(info_str,'string','');

% PRE-FILTER DESIGN
%=================================

set(info_str(1),'string','Initiating PFSHAPE with pre-designed pre-filter...');
set(info_str(2),'string','pfshape(7,w,wbd7,W7,P,[],G,1,nf0,df0);');

numc=nc0; denc=dc0;

G=freqcp(numc,denc,w);

% define initial filter
nf0=1;
df0=[1/4^2,2*0.7/4,1];

% initiate shape environment
pfshape(7,w,wbd7,W7,P,[],G,1,nf0,df0);

% setup for call to next stage when shaping completed
qftexit('qftdm2f',info_btn);
