function qftdm3d
% Fourth stage of QFTDM3
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w W1 bdb1 W2 bdb2 ...
       ubdb ...
       wl nc0 dc0

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numc=nc0; denc=dc0;

wl = wl(find(wl<5*10^6));
R = freqcp(.9*[1/.91,1],[1/1.001,1],wl); % magnitude of uncertainty circle
R=abs(R);
P=freqcp(nump,denp,wl);
G=freqcp(numc,denc,wl);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W1');
set(info_str(2),'string','chksiso(1,wl,W1,P,R,G)');

% compare design to W1
chksiso(1,wl,W1,P,R,G,[],[],win1_loc);
drawnow;
pause(2);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W2');
set(info_str(2),'string','chksiso(2,wl,W2,P,R,G)');

% recompute with a frequencies less than or equal to 10 radians/second
ind=find(wl<=10);
R = freqcp(.9*[1/.91,1],[1/1.001,1],wl); % magnitude of uncertainty circle
R=abs(R);

% recompute W2 at frequencies used for LPSHAPE
W2=[];
W2=freqcp(0.089*[1,0,0],1,wl);
W2=abs(W2);

% compare design to W2
chksiso(2,wl(ind),W2(ind),P(:,ind),R(ind),G(ind),[],[],win3_loc);

% End of computations for stage 4
last=3;
nxtstage
