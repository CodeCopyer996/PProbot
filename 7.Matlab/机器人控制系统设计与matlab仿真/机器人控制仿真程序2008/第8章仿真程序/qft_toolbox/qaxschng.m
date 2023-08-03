function qaxschng(flag)
% QAXSCHNG Set up axis change interface. (Utility Function)
%          QAXSCHNG sets up the uicontrols for changing the axis vector
%          while still within the IDE environment.

% Author: Craig Borghesani
% 5/12/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

if flag,
 f2 = gcf;
 f = get(f2,'userdata');
else
 f = gcf;
end
bthan = get(f,'userdata');
infmat = get(bthan(16),'userdata');
hint_bar = get(bthan(36),'userdata');

if flag==0,

 proc_str=[];
 if infmat(25,2)>1, proc_str=['(',int2str(infmat(25,2)),')']; end

 fig_color=[0.5,0.5,0.5];
 if infmat(9,1)==1,
  phmin=infmat(1,1); phmins=num2str(phmin,3);
  phmax=infmat(1,2); phmaxs=num2str(phmax,3);
 elseif infmat(9,1)==2,
  phmins='N/A'; phmaxs='N/A'; phmin=0; phmax=5;
 elseif infmat(9,1)==3,
  phmin=infmat(2,3); phmins=num2str(phmin,3);
  phmax=infmat(2,4); phmaxs=num2str(phmax,3);
 end
 mgmin=infmat(1,3); mgmins=num2str(mgmin,3);
 mgmax=infmat(1,4); mgmaxs=num2str(mgmax,3);

 proc_num = int2str(infmat(25,2));
 win_tag = findobj('tag',['qft5',proc_num]);
 if ~length(win_tag),
  infmat(28,1) = colordef('new','none');
  set(infmat(28,1),'name',['Axis Limits ',proc_str],'numbertitle','off',...
                   'position',[100,100,400,120],...
                   'menubar','none','color',fig_color,...
                   'vis','off','userdata',f,'tag',['qft5',proc_num],...
                   'windowstyle','modal');
  set(gca,'vis','off');
  f2 = infmat(28,1);
  infmat(29,1)=uicontrol(f2,'style','edit','pos',[75,65,80,20],...
                         'background',[1,1,1],'string',phmins,...
                         'horiz','right');
  infmat(29,2)=uicontrol(f2,'style','edit','pos',[220,65,80,20],...
                         'background',[1,1,1],'string',phmaxs,...
                         'horiz','right');
  infmat(29,3)=uicontrol(f2,'style','edit','pos',[75,15,80,20],...
                         'background',[1,1,1],'string',mgmins,...
                         'horiz','right');
  infmat(29,4)=uicontrol(f2,'style','edit','pos',[220,15,80,20],...
                         'background',[1,1,1],'string',mgmaxs,...
                         'horiz','right');
  uicontrol(f2,'style','frame','pos',[331,17,66,100],'backgroundcolor',[0,0.5020,0]);
  h(1)=uicontrol(f2,'style','push','pos',[334,94,60,20],...
            'string','Apply','callback','qaxschng(1)');
  h(2)=uicontrol(f2,'style','push','pos',[334,71,60,20],...
            'string','Cancel','callback','set(gcf,''vis'',''off'');');
  h(3)=uicontrol(f2,'style','push','pos',[334,43,60,20],'enable','off',...
            'string','UnDo','callback','qaxschng(3)');
  h(4)=uicontrol(f2,'style','push','pos',[334,20,60,20],...
            'string','Done','callback','qaxschng(4)');
  set(bthan(16),'userdata',infmat);
  t(1)=uicontrol(f2,'style','text','string','Phase Limits:','pos',[10,90,140,17],...
                 'backgroundcolor',[0,0.5020,0]);
  t(2)=uicontrol(f2,'style','text','string','Min:','pos',[10,65,60,20]);
  t(3)=uicontrol(f2,'style','text','string','Max:','pos',[155,65,60,20]);
  t(4)=uicontrol(f2,'style','text','string','Magnitude Limits:','pos',[10,40,140,17],...
                 'backgroundcolor',[0,0.5020,0]);
  t(5)=uicontrol(f2,'style','text','string','Min:','pos',[10,15,60,20]);
  t(6)=uicontrol(f2,'style','text','string','Max:','pos',[155,15,60,20]);
  set(t([2,3,5,6]),'background',fig_color,'horizontalalignment','right');
  set(t([1,4]),'horizontalalignment','left');
  if infmat(9,1)==2, set([infmat(29,1:2),t(1:3)],'enable','off'); end
  set(infmat(28,1),'vis','on');
  set(infmat(29,1),'userdata',h);
 else
  set(infmat(29,1),'string',phmins);
  set(infmat(29,2),'string',phmaxs);
  set(infmat(29,3),'string',mgmins);
  set(infmat(29,4),'string',mgmaxs);
  set(infmat(28,1),'vis','on');
  h=get(infmat(29,1),'userdata');
  set(h(3),'enable','off');
 end
 set(h(1),'userdata',[phmin,phmax]);
 set(h(2),'userdata',[mgmin,mgmax]);
 set(hint_bar,'string','Enter new values for desired axis limits');
 drawnow;

elseif any(flag==[1,4]), % Apply/Done
 if any(infmat(9,1)==[1,3]),
  phmin=str2num(get(infmat(29,1),'string'));
  phmax=str2num(get(infmat(29,2),'string'));
  mgmin=str2num(get(infmat(29,3),'string'));
  mgmax=str2num(get(infmat(29,4),'string'));
 else
  phmin=0; phmax=5;
  mgmin=str2num(get(infmat(29,3),'string'));
  mgmax=str2num(get(infmat(29,4),'string'));
 end
 if length([phmin,phmax,mgmin,mgmax])==4,
  if phmin<phmax & mgmin<mgmax,
   if infmat(9,1)==1,
    if any(abs(infmat(1,:)-[phmin,phmax,mgmin,mgmax])>0.5),
     infmat(26,:)=infmat(1,:);
     infmat(1,:)=[phmin,phmax,mgmin,mgmax];
     infmat(27,:)=infmat(1,:);
     set(bthan(16),'userdata',infmat);
     qnicplt(f);
     set(infmat(24,1),'xlim',[phmin,phmax],'ylim',[mgmin,mgmax]);
     copybnds(f);
     drawnow;
    end
   elseif infmat(9,1)==2,
    if any(infmat(1,3:4)~=[mgmin,mgmax]),
     infmat(26,:)=infmat(1,:);
     infmat(1,3:4)=[mgmin,mgmax];
     infmat(27,:)=infmat(1,:);
     set(bthan(16),'userdata',infmat);
     qmagplt(f);
     set(infmat(24,1),'ylim',[mgmin,mgmax]);
    end
   elseif infmat(9,1)==3,
    if any([infmat(1,3:4),infmat(2,3:4)]~=[phmin,phmax,mgmin,mgmax]),
     infmat(26,:)=[infmat(1,3:4),infmat(2,3:4)];
     infmat(1,3:4)=[mgmin,mgmax];
     infmat(2,3:4)=[phmin,phmax];
     infmat(27,3:4)=infmat(2,3:4);
     set(bthan(16),'userdata',infmat);
     mgphplot(f);
     set(infmat(24,1),'ylim',[mgmin,mgmax]);
     set(infmat(24,2),'ylim',[phmin,phmax]);
    end
   end
   if flag == 4,
    set(infmat(28,1),'vis','off');
   else
    h = get(infmat(29,1),'userdata');
    set(h(2),'callback','qaxschng(2)');
    set(h(3),'enable','on');
    figure(infmat(28,1));
   end
  else
   errordlg('MAX must be greater than MIN','Message','on');
  end
 else
  errordlg('Invalid input data','Message','on');
 end
elseif any(flag == [2,3]), % UnDo/Cancel
 h = get(infmat(29,1),'userdata');
 if infmat(9,1)==1,
  if flag==2,
   infmat(26,:)=infmat(1,:);
   infmat(1,:)=[get(h(1),'userdata'),get(h(2),'userdata')];
  else
   tempaxs=infmat(1,:);
   infmat(1,:)=infmat(26,:);
   infmat(26,:)=tempaxs;
  end
  set(infmat(24,1),'xlim',infmat(1,1:2),'ylim',infmat(1,3:4));
  set(bthan(16),'userdata',infmat);
  qnicplt(f);
 elseif infmat(9,1)==2,
  if flag==2,
   infmat(26,:)=infmat(1,:);
   infmat(1,3:4)=get(h(2),'userdata');
  else
   tempaxs=infmat(1,:);
   infmat(1,:)=infmat(26,:);
   infmat(26,:)=tempaxs;
  end
  set(infmat(24,1),'ylim',infmat(1,3:4));
  set(bthan(16),'userdata',infmat);
  qmagplt(f);
 elseif infmat(9,1)==3,
  if flag==2,
   infmat(26,:)=[infmat(1,3:4),infmat(2,3:4)];
   infmat(28,2:3) = infmat(1,1:2);
   axsm=get(h(2),'userdata');
   axsp=get(h(1),'userdata');
  else
   axsm=infmat(1,:);
   axsp=infmat(2,:);
   infmat(26,:)=[axsm(3:4),axsp(3:4)];
   infmat(28,2:3)=axsm(1,1:2);
   axsm=[infmat(28,2:3),infmat(26,1:2)];
   axsp=[infmat(28,2:3),infmat(26,3:4)];
  end
  set(infmat(24,1),'xlim',axsm(1:2),'ylim',axsm(3:4));
  set(infmat(24,1),'xlim',axsp(1:2),'ylim',axsp(3:4));
  infmat(1,:)=axsm; infmat(2,3:4)=axsp(3:4);
  set(bthan(16),'userdata',infmat);
  mgphplot(f);
 end
 if flag == 2,
  set(infmat(28,1),'vis','off');
 else
  if infmat(9,1)==1,
   set(infmat(29,1),'string',num2str(infmat(1,1),3));
   set(infmat(29,2),'string',num2str(infmat(1,2),3));
   set(infmat(29,3),'string',num2str(infmat(1,3),3));
   set(infmat(29,4),'string',num2str(infmat(1,4),3));
  elseif infmat(9,1)==2,
   set(infmat(29,3),'string',num2str(infmat(1,3),3));
   set(infmat(29,4),'string',num2str(infmat(1,4),3));
  elseif infmat(9,1)==3,
   set(infmat(29,1),'string',num2str(infmat(2,3),3));
   set(infmat(29,2),'string',num2str(infmat(2,4),3));
   set(infmat(29,3),'string',num2str(infmat(1,3),3));
   set(infmat(29,4),'string',num2str(infmat(1,4),3));
  end
  set(h(3),'enable','off');
  figure(infmat(28,1));
 end
end
