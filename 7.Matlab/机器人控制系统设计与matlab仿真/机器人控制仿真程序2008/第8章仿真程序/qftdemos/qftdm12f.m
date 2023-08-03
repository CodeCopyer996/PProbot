function qftdm12f
% Sixth stage of QFTDM12
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn T1 T2 T3 ...
       T nump denp nompt R w P ...
       W1 bdb1 W2 bdb2 W3 bdb3 ...
       ubdb ...
       wl nc0 dc0

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Initiating DLPSHAPE with pre-designed controller');
set(info_str(2),'string','dlpshape(T,wl,ubdb,nL0,dL0,nc0,dc0);');

% define a frequency array for loop shaping
wl = [logspace(-2,log10((pi-.2)/T),100),...
      logspace(log10((pi-.19)/T),log10(pi/T),25)];

% obtain nominal plant from plant set
nL0=nump(nompt,:);
dL0=denp(nompt,:);

% no delay
del0=0;

% select the proper controller for the chosen sampling time
% T = 0.001
if T==0.001,
 nc0=1950*[1,-.96];
 dc0=[1,-.8];
elseif T==0.003,
 nc0=4721*[1,-.9];
 dc0=[1,-.212];
elseif T==0.01,
 nc0=1998*conv([1,-.3],[1,-.63]);
 dc0=conv([1,-.2],[1,.745]);
end

dlpshape(T,wl,ubdb,nL0,dL0,nc0,dc0);

% setup for call to next stage
qftexit('qftdm12g',info_btn);
