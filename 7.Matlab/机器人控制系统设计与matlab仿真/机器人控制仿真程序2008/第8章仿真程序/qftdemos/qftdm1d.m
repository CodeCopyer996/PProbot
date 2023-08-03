function qftdm1d(mode)
% Fourth stage of QFTDM1
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp w P bdb1 bdb2 bdb3 W1 W2 W3 ...
       ubdb ...
       wl nL0 dL0 del0 ch_win nc0 dc0

if nargin == 0,
   % close all windows from last stage and clear strings in information window
   close(findobj('tag','qft'));
   set(info_str,'string','');

   % DESIGN
   %=================================

   % define a frequency array for loop shaping
   wl = logspace(-2,3,100);

   % obtain nominal plant from plant set
   nL0=nump(nompt,:);
   dL0=denp(nompt,:);

   % no delay
   del0=0;

   % setup choices window
   ch_win = colordef('new','none');
   fig_color=[128/255,128/255,128/255];
   set(ch_win,'name','Initial Controller (select one)','numbertitle','off',...
               'pos',[10,120,280,250],'color',fig_color,'tag','qft',...
               'vis','on');

   % controller 1
   uicontrol(ch_win,'style','text','pos',[70,220,210,20],...
            'string','379*(s/42 + 1)');
   uicontrol('style','text','pos',[70,200,210,20],...
            'string','-------------------------');
   uicontrol(ch_win,'style','text','pos',[70,180,210,20],...
            'string','s^2/247^2+ s/247 + 1');

   % controller 2
   uicontrol(ch_win,'style','text','pos',[70,135,210,20],...
            'string','379*(s/42 + 1)');
   uicontrol(ch_win,'style','text','pos',[70,115,210,20],...
            'string','------------------------');
   uicontrol(ch_win,'style','text','pos',[70,95,210,20],...
            'string','s/165 + 1');

   % controller 3
   uicontrol(ch_win,'style','text','pos',[70,50,210,20],...
            'string','1');
   uicontrol(ch_win,'style','text','pos',[70,30,210,20],...
            'string','------------------------');
   uicontrol(ch_win,'style','text','pos',[70,10,210,20],...
            'string','1');

   % display info in information window
   set(info_str(1),'string','Invoking LPSHAPE with pre-designed controller');
   set(info_str(2),'string','lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);');

   % setup push buttons designating choices
   uicontrol(ch_win,'style','push','pos',[20,185,40,25],'string','1',...
            'callback','qftdm1d(1)');
   uicontrol(ch_win,'style','push','pos',[20,100,40,25],'string','2',...
            'callback','qftdm1d(2)');
   uicontrol(ch_win,'style','push','pos',[20,15,40,25],'string','3',...
            'callback','qftdm1d(3)');

elseif mode == 1,

   close(ch_win);
   drawnow;

   % setup callback strings for specified choices
   nc0=379*[1/42,1];
   dc0=[1/247^2,1/247,1];
   del0 = 0;

   lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);

   % append onto choice strings the function that sets up the call to the next
   % stage.  the file name of the next stage is passed as input to QFTEXIT
   qftexit('qftdm1e',info_btn);

elseif mode == 2,

   close(ch_win);
   drawnow;

   nc0=379*[1/42,1];
   dc0=[1/165,1];
   del0 = 0;

   lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);

   % append onto choice strings the function that sets up the call to the next
   % stage.  the file name of the next stage is passed as input to QFTEXIT
   qftexit('qftdm1e',info_btn);

elseif mode == 3,

   close(ch_win);
   drawnow;

   nc0=1;
   dc0=1;
   del0 = 0;

   lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);

   % append onto choice strings the function that sets up the call to the next
   % stage.  the file name of the next stage is passed as input to QFTEXIT
   qftexit('qftdm1e',info_btn);

end
