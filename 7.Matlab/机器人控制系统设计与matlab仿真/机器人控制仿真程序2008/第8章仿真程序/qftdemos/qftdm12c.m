function qftdm12c(t)
% Third stage of QFTDM12
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn T1 T2 T3 ...
       T nump denp nompt R w P

% clear strings in information window
set([T1,T2,T3],'vis','off');
set(info_str,'string','');
set(info_btn,'vis','on');
drawnow;

% PROBLEM DATA
%=================================

% display information string in information window
set(info_str(1),'string','Computing plant templates...');
T = t;

% compute the boundary of the plant templates
c = 1;
k = 10;
b = 20;
for a = logspace(0,0.6989,10),
 A=(b*(1-exp(-a*T))-a*(1-exp(-b*T)))/(a*b*(b-a));
 B=(a*exp(-a*T)*(1-exp(-b*T))-b*exp(-b*T)*(1-exp(-a*T)))/(a*b*(b-a));
 nump(c,:) = k*[A B];
 denp(c,:) = conv([1 -exp(-a*T)],[1 -exp(-b*T)]);
 c=c+1;
end

k = 1;
b = 30;
for a = logspace(0,0.6989,10),
 A=(b*(1-exp(-a*T))-a*(1-exp(-b*T)))/(a*b*(b-a));
 B=(a*exp(-a*T)*(1-exp(-b*T))-b*exp(-b*T)*(1-exp(-a*T)))/(a*b*(b-a));
 nump(c,:) = k*[A B];
 denp(c,:) = conv([1 -exp(-a*T)],[1 -exp(-b*T)]);
 c=c+1;
end

a = 5;
b = 30;
for k = logspace(0,1,10),
 A=(b*(1-exp(-a*T))-a*(1-exp(-b*T)))/(a*b*(b-a));
 B=(a*exp(-a*T)*(1-exp(-b*T))-b*exp(-b*T)*(1-exp(-a*T)))/(a*b*(b-a));
 nump(c,:) = k*[A B];
 denp(c,:) = conv([1 -exp(-a*T)],[1 -exp(-b*T)]);
 c=c+1;
end

a = 1;
b = 20;
for k = logspace(0,1,10),
 A=(b*(1-exp(-a*T))-a*(1-exp(-b*T)))/(a*b*(b-a));
 B=(a*exp(-a*T)*(1-exp(-b*T))-b*exp(-b*T)*(1-exp(-a*T)))/(a*b*(b-a));
 nump(c,:) = k*[A B];
 denp(c,:) = conv([1 -exp(-a*T)],[1 -exp(-b*T)]);
 c=c+1;
end

% define nominal plant case
nompt = 21;

% define radius
R = 0;

% Compute ahead frequency response (speed up computations)
w = [.1,5,10,100,pi/T];
P=dfreqcp(T,nump,denp,w);

% PLOT TEMPLATES
plottmpl(w,w,P,nompt);
title('Plant Templates');

% End of computations for stage 1

next_stage = 'qftdm12d';
last=0;
nxtstage
