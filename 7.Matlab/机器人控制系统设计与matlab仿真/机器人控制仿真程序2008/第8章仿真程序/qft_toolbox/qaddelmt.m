function qaddelmt(flag)
% QADDELMT Set up for Add interface. (Utility Function)
%          QADDELMT sets up the ADD window for the various elements allowed
%          within the IDEs.

% Author: Craig Borghesani
% 8/31/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

if flag==0,   % setup phase
 qclswin(0);
 f=gcf;
 bthan=get(f,'userdata');
 cont=get(bthan(3),'userdata');
 hint_bar = get(bthan(36),'userdata');
 [rcont,ccont] = size(cont);

 if rcont > 40,
  set(hint_bar,'Element limit reached.  Use <Reduction...>.');
  return;
 end

 set(bthan([1,8,29]),'enable','off');
 cntdisp(f,cont,0);

 infmat=get(bthan(16),'userdata');
 lomat=get(bthan(1),'userdata');
 set(bthan(19),'userdata',cont);
 set(bthan(20),'userdata',lomat);
 flag3=infmat(9,1);
 T=get(bthan(13),'userdata');
 fig_color=[0.5,0.5,0.5];

 proc_str=[];
 if infmat(25,2)>1, proc_str=[' (',int2str(infmat(25,2)),')']; end

 if flag3~=2, hw=20*(7+length(T))+75;
 else hw=20*6+75; end

 proc_num = int2str(infmat(25,2));
 win_tag = findobj('tag',['qft1',proc_num]);
 if ~length(win_tag),
  infmat(14,1) = colordef('new','none');
  set(infmat(14,1),'vis','off','name',['Add ',proc_str],...
                   'numbertitle','off','position',[50,50,230,hw+86],...
                   'menubar','none','resize','off','color',fig_color,...
                   'userdata',f,'tag',['qft1',proc_num]);
  f2=infmat(14,1);
  set(gca,'vis','off');
  elmtbutn(flag3,f,f2);
  uicontrol(f2,'style','frame','pos',[48,3,134,49],'backgroundcolor',[0,0.5020,0]);
  infmat(13,1)=uicontrol(f2,'style','push','pos',[51,29,60,20],...
               'string','Apply');
  infmat(13,2)=uicontrol(f2,'style','push','pos',[51,6,60,20],...
               'string','Cancel','callback','qaddelmt(8)');
  infmat(13,3)=uicontrol(f2,'style','push','pos',[119,29,60,20],...
               'string','UnDo','callback','qundoit(1)');
  infmat(13,4)=uicontrol(f2,'style','push','pos',[119,6,60,20],...
               'string','Done','callback','qelmts(7,0)');
  set(infmat(13,[1,3:4]),'enable','off');
  infmat(16,1)=uicontrol(f2,'style','edit','pos',[117,hw+5,100,20]);
  infmat(16,2)=uicontrol(f2,'style','edit','pos',[117,hw+32,100,20]);
  infmat(16,3)=uicontrol(f2,'style','edit','pos',[117,hw+59,100,20]);
  set(infmat(16,1:3),'background',[1,1,1],'enable','off','horiz','right');
  infmat(19,1)=uicontrol(f2,'style','text','pos',[15,hw+5,100,17]);
  infmat(19,2)=uicontrol(f2,'style','text','pos',[15,hw+32,100,17]);
  infmat(19,3)=uicontrol(f2,'style','text','pos',[15,hw+59,100,17]);
  set(infmat(19,1:3),'background',fig_color,'horizontalalignment','right');
  set(infmat(14,1),'vis','on');
 else
  set(infmat(16,1:3),'enable','off','string','');
  set(infmat(19,1:3),'string','');
  set(infmat(13,[1,3:4]),'enable','off');
  set(infmat(14,1),'vis','on');
 end
 set(bthan(16),'userdata',infmat);
 set(hint_bar,'string','Add new elements to the present design');
 drawnow;
end

if (flag ~= 0),
 f2=gcf;
 f=get(f2,'userdata');
 bthan=get(f,'userdata');
 infmat=get(bthan(16),'userdata');
 hint_bar = get(bthan(36),'userdata');

 if flag~=8,
  set(hint_bar,'string','Enter values into the appropriate edit boxes');
  set(infmat(16,1:3),'string','','enable','off');
  set(infmat(19,1:3),'string','');
  set(infmat(13,[1,4]),'enable','on','callback',['qelmts(',num2str(flag),',0)']);
 end
end

if any(flag==[1 2]),   % add pole or zero
 str=['pole=';'zero='];
 set(infmat(16,1),'enable','on');
 set(infmat(19,1),'string',str(flag,:));

elseif any(flag==[3 4]),  % add second order
 set(infmat(16,1:2),'enable','on');
 if flag==3,
  set(infmat(19,2),'string','zeta(pole)=');
  set(infmat(19,1),'string','wn(pole)=');
 else
  set(infmat(19,2),'string','zeta(zero)=');
  set(infmat(19,1),'string','wn(zero)=');
 end

elseif any(flag==[0.5,0.6,0.7]),  % add integrator/differentiator/delay/pred
 set(infmat(16,1),'enable','on');
 set(infmat(19,1),'string','n=');

elseif flag==5,   % add lead/lag
 set(infmat(16,1:2),'enable','on');
 set(infmat(19,2),'string','phase=');
 set(infmat(19,1),'string','w=');

elseif flag==6,   % add notch
 set(infmat(16,1:3),'enable','on');
 set(infmat(19,3),'string','zeta1(zero)=');
 set(infmat(19,2),'string','zeta2(pole)=');
 set(infmat(19,1),'string','wn=');

elseif flag==8, % Cancel
 set(bthan([1,8,29]),'enable','on');
 if length(get(bthan(30),'userdata')),
  set(bthan(30),'userdata',[]);
  v2=get(bthan(21),'userdata');
  vo2=get(bthan(22),'userdata');
  if infmat(9,1)==1,
   set([v2(:);vo2(:)],'vis','off');
  else
   set(v2,'vis','off');
  end
 end
 set(bthan([19,20]),'userdata',[]);
 qclswin(1);

end
