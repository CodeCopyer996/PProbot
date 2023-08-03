function qclswin(flag)
% QCLSWIN Set secondary windows to visible-off. (Utility Function)
%         QCLSWIN sets all secondary windows (Add, Delete, Iterate, etc)
%         within the shaping IDE to visible-off.

% Author: Craig Borghesani
% 9/3/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

% if another figure is open over the main figure, then main figure's handle
% is stored in the userdata of that figure
if any(flag==[1,2,3]),
 f2=gcf; a2=gca;
 f=get(f2,'userdata');
else   % no figure open over main window
 f=gcf;
end
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
cont=get(bthan(3),'userdata');
T=get(bthan(13),'userdata');
qabtns = get(bthan(34),'userdata');
hint_bar = get(bthan(36),'userdata');
set(bthan(20),'userdata',[]);
set(bthan([1,8,29]),'enable','on');
proc_num = int2str(infmat(25,2));
if infmat(9,1)==1,
 set(qabtns,'enable','on');
else
 set(qabtns([1:3,5]),'enable','on');
end

% View, Edit, Del, Iterate, Reduction, Conversion window
set(findobj('tag',['qft3',proc_num]),'vis','off');

if any(flag==[0,1]),

% Erase frequency markers
 if infmat(9,1)==3, set(infmat(6,1:2),'vis','off','userdata',[]);
 else set(infmat(6,1),'vis','off','userdata',[]); end

% Add
 set(findobj('tag',['qft1',proc_num]),'vis','off');

% Frequency window
 set(findobj('tag',['qft2',proc_num]),'vis','off');

% Grammian plot window
 set(findobj('tag',['qft4',proc_num]),'vis','off');

% Axis Change window
 set(findobj('tag',['qft5',proc_num]),'vis','off');

% Out to Workspace window
 set(findobj('tag',['qft6',proc_num]),'vis','off');

% Exit CAD window
 set(findobj('tag',['qft7',proc_num]),'vis','off');

% Remove secondary line
 v2=get(bthan(21),'userdata');
 vo2=get(bthan(22),'userdata');
 if infmat(9,1)==1,
  set([v2(:);vo2(:)],'vis','off');
 else
  set(v2,'vis','off');
 end
 set(bthan(20),'userdata',[]);

% reseting button-state functions
 set(f,'windowbuttonupfcn','');
 if length(get(f,'windowbuttonmotionfcn'))>1,
  set(f,'windowbuttonmotionfcn','modisp');
  lomat=get(bthan(1),'userdata');
  lomat(3+(infmat(9,1)==2),:)=lomat(3+(infmat(9,1)==2),:)*0+1;
  set(bthan(1),'userdata',lomat);
 end

% reset complex and frequency values
 infmat(4,3)=0;
 infmat(3,3)=0;

% add 2/2 element to controller
 if any(infmat(9,1)==[1,3]),
  cont2 = get(bthan(31),'userdata');
  if length(cont2),
   cont(1,1) = cont(1,1)*cont2(1,1);
   if length(T),
    cont(3,1) = cont(3,1)+cont2(3,1);
    cont2(1:3,:) = [];
   else
    cont2(1:2,:) = [];
   end
   set(bthan(3),'userdata',[cont;cont2]);
   set(bthan(31),'userdata',[]);
  end
 end

elseif flag==3,
 set(findobj('tag',['qft4',proc_num]),'vis','off');
 set(findobj('tag',['qft3',proc_num]),'vis','on');
end
set(bthan(16),'userdata',infmat);
set(hint_bar,'string','Ready');
if length(get(gcf,'userdata'))==1,
 figure(f);
end
