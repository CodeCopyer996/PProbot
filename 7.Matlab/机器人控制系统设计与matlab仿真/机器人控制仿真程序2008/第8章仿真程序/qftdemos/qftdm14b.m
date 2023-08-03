function qftdm14b
% Second stage of QFTDM14
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       P wp in

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% PLOTTING TEMPLATES

set(info_str(1),'string','Plotting plant templates (pre-computed)....')
set(info_str(2),'string','plottmpl(wp(in),wp(in),P(:,in),nompt)')
plottmpl(wp(in),wp(in),P(:,in),nompt), title('Plant Templates')

% End of computations for stage 2

next_stage = 'qftdm14c';
last=0;
nxtstage
