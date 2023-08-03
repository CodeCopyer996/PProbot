function qftdm1e
% Fifth stage of QFTDM1
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp w P bdb1 bdb2 bdb3 W1 W2 W3 ...
       ubdb ...
       wl nL0 dL0 del0 ch_win nc0 dc0 R

% clear strings in information window
set(info_str,'string','');

% ANALYSIS
%=================================

set(info_str(1),'string','Re-define a more dense plant template (100 points)...');

c = 1; k = 10; b = 20;
for a = logspace(log10(1),log10(5),25),
 nump(c,:) = k;  denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
k = 1; b = 30;
for a = logspace(log10(1),log10(5),25),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = 30; a = 5;
for k = logspace(log10(1),log10(10),25),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = 20; a = 1;
for k = logspace(log10(1),log10(10),25),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end

numC=nc0; denC=dc0;

P=freqcp(nump,denp,wl);
G=freqcp(numC,denC,wl);

% display info in information window
set(info_str(1),'string','Margins specification...');
set(info_str(2),'string','chksiso(1,wl,W1,P,R,G)');

% compare design to W1
chksiso(1,wl,W1,P,R,G,[],[],win1_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Output disturbance rejection specification...');
set(info_str(2),'string','chksiso(2,wl,W2,P,R,G)');

% recompute W2 at frequencies used for LPSHAPE
ind=find(wl<=15);
W2=[];
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],wl));% weight computed at wl
% compare design to W2
chksiso(2,wl(ind),W2(ind),P(:,ind),R,G(ind),[],[],win2_loc);
drawnow;

% display info in information window
set(info_str(1),'string','Input disturbance rejection specification...');
set(info_str(2),'string','chksiso(3,wl,W3,P,R,G)');

% compare design to W3
chksiso(3,wl(ind),W3,P(:,ind),R,G(ind),[],[],win3_loc);

% End of presentation
last=3;
nxtstage
