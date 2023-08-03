function qftdm8b
% Second stage of QFTDM8
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump1 denp1 P1 w nump2 denp2 P2 ...
       W1 R bdb1 W1 bdb2

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% CLOSING OUTER LOOP FIRST
set(info_str(1),'string','Closing outer first...');
pause(2);

set(info_str(1),'string','Computing bounds...');
set(info_str(2),'string','bdb1=sisobnds(1,w,w,W1,P1,R,nompt);');

W1 = 1.2;  % define weight
R=0;
bdb1 = sisobnds(1,w,w,W1,P1,R,nompt);

plotbnds(bdb1,[],[],win1_loc);
title('Robust Robust Stability Bounds');
drawnow;

set(info_str(2),'string','bdb2=genbnds(10,w,wbd2,W2,P1)');

wbd2=[.1,1,5,10]; % the frequency array
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],w));% weight computed at w
a=1; b=0; c=1; d=mulcp(P1,P2,2);
bdb2=genbnds(10,w,wbd2,W2,a,b,c,d,P1(nompt,:));

plotbnds(bdb2,[],[],win3_loc);
title('Robust Output Disturbance Rejection Bounds');

% End of computations for stage 1
next_stage = 'qftdm8c';
last=1;
nxtstage
