function qftdm9f
% Sixth stage of QFTDM9
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

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numf=nf0; denf=df0;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W1');
set(info_str(2),'string','chksiso(1,wl,W1,P,R,G)');

P=freqcp(nump,denp,wl);
G=freqcp(nc0,dc0,wl);

% compare design to W1
chksiso(1,wl,W1,P,R,G,[],[],win1_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W2');
set(info_str(2),'string','chksiso(2,wl,W2,P,R,G,[])');

% check at all frequencies less than 500 rad/sec
ind = find(wl<=500);
F=freqcp(numf,denf,wl); mf=abs(F);
w2=[]; W2=[];
w2=freqcp(2*pi*10,[1,1],wl); w2=abs(w2); W2=(1 ./ w2);

% compare design to W2
chksiso(2,wl(ind),W2(ind),P(:,ind),R,G(ind),[],[],win2_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W4');
set(info_str(2),'string','chksiso(4,wl,W4,P,R,G,[],F)');

% compare design to W4
chksiso(4,wl(ind),W4,P(:,ind),R,G(ind),[],F(ind),win3_loc);

% End of computations for stage 6
last=3;
nxtstage
