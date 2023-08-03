function qftdm14e
% Fifth stage of QFTDM14
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       P P0 wp in bdb1 W1 bdb2 W2 phs ...
       ubdb ...
       nc0 dc0 wl

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================

set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller');
set(info_str(2),'string','lpshape(wl,ubdb,P0,[],del0,nc0,dc0,phs);');

% define a frequency array for loop shaping
wl = wp;

% no delay
del0=0;

% define initial controller
[nc0,dc0]=getqft('sisocdc.mat');

lpshape(wl,ubdb,P0,[],del0,nc0,dc0,phs);

% setup for call to next stage
qftexit('qftdm14f',info_btn);
