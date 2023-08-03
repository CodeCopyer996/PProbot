function qftdm14d
% Fourth stage of QFTDM14
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       P wp in bdb1 W1 bdb2 W2 phs ...
       ubdb

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% WORKING WITH THE COMPUTED BOUNDS
%=================================

% display info in information window
set(info_str(1),'string','Grouping bounds....');
set(info_str(2),'string','bdb=grpbnds(bdb1,bdb2)');
% grouping bounds
bdb=grpbnds(bdb1,bdb2);
pause(2);

% display info in information window
set(info_str(1),'string','Plotting all bounds superimposed....');
set(info_str(2),'string','plotbnds(bdb)');

% plot all bounds
plotbnds(bdb,[],phs,win1_loc);
title('All Bounds');
drawnow;

% display info in information window
set(info_str(1),'string','Intersecting performance bounds....');
set(info_str(2),'string','ubdb=sectbnds(bdb)');
pause(2);

% unionize performance specifications
ubdb=sectbnds(bdb);

% display info in information window
set(info_str(1),'string','Plotting intersection of bounds....');
set(info_str(2),'string','plotbnds(ubdb)');

% plotting intersected bounds
plotbnds(ubdb,[],phs,win3_loc);
title('Intersection of Bounds');

% End of computations for stage 3

next_stage = 'qftdm14e';
last=2;
nxtstage
