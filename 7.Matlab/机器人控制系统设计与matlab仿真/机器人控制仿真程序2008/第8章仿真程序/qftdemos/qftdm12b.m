% define sampling time

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.3 $

set(info_str(1),'string','Three sampling times with controllers:')
T1=uicontrol(info_win,'style','push','pos',[50,5,60,20],'string','T=0.001',...
         'callback','T=0.001;qftdm12c');
T2=uicontrol(info_win,'style','push','pos',[145,5,60,20],'string','T=0.003',...
         'callback','T=0.003;qftdm12c');
T3=uicontrol(info_win,'style','push','pos',[240,5,60,20],'string','T=0.01',...
         'callback','T=0.01;qftdm12c');
