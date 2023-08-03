function qftdm2f
% Sixth stage of QFTDM2
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn ...
       nump denp P w ...
       bdb1 bdb7 W1 W7 ...
       ubdb ...
       nc0 dc0 wl ...
       nf0 df0 G

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

numf=nf0; denf=df0;

P=freqcp(nump,denp,wl);
G=freqcp(nc0,dc0,wl);
F=freqcp(numf,denf,wl);

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W1');
set(info_str(2),'string','chksiso(1,wl,W1,P,[],G)');

% compare design to W1
chksiso(1,wl,W1,P,[],G,[],[],win1_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Compare closed-loop design to W7');
set(info_str(2),'string','chksiso(7,wl,W1,P,[],G,[],F)');

ind=find(wl<=20);

% tracking weight
mu=[]; ml=[]; W7=[];

mu=freqcp(.6584*[1,30],[1,4,19.752],wl);
ml=freqcp(120,[1,17,82,120],wl);
W7=[abs(mu);abs(ml)];

chksiso(7,wl(ind),W7(:,ind),P(:,ind),[],G(ind),[],F(ind),win3_loc);

% End of computations for stage 6

last=3;
nxtstage
