function qfrqchng(flag)
% QFRQCHNG Set up frequency change interface. (Utility Function)
%          QFRQCHNG sets up the uicontrols to change the frequency vector
%          while still within the CAD environment.

% Author: Craig Borghesani
% 9/5/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

if flag,
 f2=gcf;
 f = get(f2,'userdata');
else
 qclswin(0);
 f = gcf;
end
bthan = get(f,'userdata');
infmat = get(bthan(16),'userdata');

if flag==0,

 T=get(bthan(13),'userdata');
 hint_bar = get(bthan(36),'userdata');

 proc_str=[];
 if infmat(25,2)>1, proc_str=['(',int2str(infmat(25,2)),')']; end

 fig_color=[0.5,0.5,0.5];
 nom=get(bthan(2),'userdata');
 if length(nom),
  set(bthan([1,8,29]),'enable','off');
  lomat=get(bthan(1),'userdata');
  w=lomat(1,:);
  first=num2str(w(1),3);
  last=num2str(w(length(w)),3);
  len=int2str(length(w));
  proc_num = int2str(infmat(25,2));
  win_tag = findobj('tag',['qft2',proc_num]);
  if ~length(win_tag),
   infmat(12,1) = colordef('new','none');
   set(infmat(12,1),'name',['Frequency ',proc_str],'numbertitle','off',...
                    'position',[100,100,250,126],...
                    'menubar','none','color',fig_color,...
                    'vis','off','userdata',f,'tag',['qft2',proc_num]);
   set(gca,'vis','off');
   f2 = infmat(12,1);
   infmat(12,2)=uicontrol(f2,'style','edit','pos',[81,94,80,20],...
                          'background',[1,1,1],'string',first,'horiz','right');
   infmat(12,3)=uicontrol(f2,'style','edit','pos',[81,67,80,20],...
                          'background',[1,1,1],'string',last,'horiz','right');
   infmat(12,4)=uicontrol(f2,'style','edit','pos',[81,40,80,20],...
                          'background',[1,1,1],'string',len,'horiz','right');
   uicontrol(f2,'style','frame','pos',[181,23,66,100],'backgroundcolor',[0,0.5020,0]);
   h(1)=uicontrol(f2,'style','push','pos',[184,100,60,20],...
                'string','Apply','callback','qfrqchng(1)');
   h(2)=uicontrol(f2,'style','push','pos',[184,77,60,20],...
                'string','Cancel','callback','qfrqchng(2)');
   h(3)=uicontrol(f2,'style','push','pos',[184,49,60,20],...
                'string','UnDo','callback','qfrqchng(3)');
   h(4)=uicontrol(f2,'style','push','pos',[184,26,60,20],...
                'string','Done','callback','qfrqchng(4)');
   h(5)=uicontrol(f2,'style','check','string','Pad Frequency Vector',...
                  'value',0,'pos',[10,10,171,20],'background',fig_color);
   set(h(3),'enable','off');
   set(infmat(12,2),'userdata',h);
   set(bthan(16),'userdata',infmat);
   t(1)=uicontrol(f2,'style','text','string','Min:','pos',[6,94,70,17]);
   t(2)=uicontrol(f2,'style','text','string','Max:','pos',[6,67,70,17]);
   t(3)=uicontrol(f2,'style','text','string','Length:','pos',[6,40,70,17]);
   set(t,'background',fig_color,'horizontalalignment','right');
   set(infmat(12,1),'vis','on');
  else
   h=get(infmat(12,2),'userdata');
   set(h(3),'enable','off');
   set(infmat(12,2),'string',first);
   set(infmat(12,3),'string',last);
   set(infmat(12,4),'string',len);
   set(infmat(12,1),'vis','on');
  end
  set(h(1),'userdata',lomat);
  set(hint_bar,'string','Enter new frequency range');
  drawnow;
 else
  if infmat(9,1)==1,
   errordlg('Plant in complex format','Message','on');
  else
   errordlg('Initial loop in complex format','Message','on');
  end
 end
elseif any(flag==[1,4]), % Apply/Done
 h = get(infmat(12,2),'userdata');
 lomat=get(bthan(1),'userdata');
 T = get(bthan(13),'userdata');
 cur_fir = log10(lomat(1,1));
 cur_las = log10(lomat(1,length(lomat(1,:))));
 cur_len = length(lomat(1,:));
 fir=log10(str2num(get(infmat(12,2),'string')));
 las=log10(str2num(get(infmat(12,3),'string')));
 len=str2num(get(infmat(12,4),'string'));
 go_for_it = 1;
 if length(T),
  if las > log10(pi/T),
   las = log10(pi/T);
  end
 end

 if go_for_it,
  set(h(2),'userdata',lomat);
  delay=infmat(10,1);
  nom=get(bthan(2),'userdata');
  cont=get(bthan(3),'userdata');
  wbs=get(bthan(11),'userdata');
  w=logspace(real(fir),real(las),len); w=sort([w,wbs]); w(find(diff(w)==0))=[];
  nomt=cntpars(nom(1,:),nom(2,:),T);
  contnom=[cont;nomt];
% pad frequency vector
  if get(h(5),'value'),
   for k=1:length(contnom(:,1)),
    if any(contnom(k,4)==[3,4]),
     if contnom(k,1)<0.4,
      w=qfrqenh(contnom(k,2),contnom(k,1),w,T);
     end
    elseif contnom(k,4)==6,
     ztas=contnom(k,1:2);
     zta=ztas((ztas(1)>ztas(2))+1);
     w=qfrqenh(contnom(k,3),zta,w,T);
    end
   end
   if length(T),
    len_w = length(w);
    w_extra = logspace(log10(w(len_w-1)),log10(w(len_w)),20);
    w = sort([w,w_extra]);
   end
  end
  if infmat(9,1)==1,
   nlo=1;
   if length(nom),
    nlo=qcpqft(nom(1,:),nom(2,:),w,T);
   end
   clo=qcntbode(cont,w,T).*exp(-i*w*delay);
   lo=nlo.*clo;
  else
   infmat(1,1:2)=[w(1),w(length(w))];
   infmat(2,1:2)=infmat(1,1:2);
   infmat(27,1:2)=infmat(1,1:2);
   lo=qcntbode(cont,w,T).*exp(-i*w*delay);
  end
  lomat=[w;lo;ones(1,length(w))];
  set(bthan(1),'userdata',lomat);
  set(bthan(16),'userdata',infmat);
  if infmat(9,1)==1, qnicplt(f);
  elseif infmat(9,1)==3,
   set(infmat(24,1:2),'xlim',infmat(1,1:2));
   mgphplot(f);
  end
  if flag==4,
   set(bthan([1,8,29]),'enable','on');
   set(f2,'vis','off');
  else
   cur_firw = num2str(w(1),3);
   cur_lasw = num2str(w(length(w)),3);
   cur_lenw = int2str(length(w));
   set(infmat(12,2),'string',cur_firw);
   set(infmat(12,3),'string',cur_lasw);
   set(infmat(12,4),'string',cur_lenw);
   set(h(2),'callback','qfrqchng(2)');
   set(h(3),'enable','on');
  end

  if flag == 4,
   set(bthan([1,8,29]),'enable','on');
   set(f2,'vis','off');
  end
 else
  errordlg('Maximum frequency cannot be greater than pi/T','Message','on');
  set(infmat(12,3),'string',num2str(pi/T));
 end

elseif any(flag==[2,3]), % UnDo/Cancel
 h = get(infmat(12,2),'userdata');
 if flag==2,
  lomat = get(h(1),'userdata');
 else
  lomat = get(h(2),'userdata');
 end
 w = lomat(1,:);
 las_fir = log10(w(1));
 las_las = log10(w(length(w)));
 las_len = length(w);
 fir=log10(str2num(get(infmat(12,2),'string')));
 las=log10(str2num(get(infmat(12,3),'string')));
 len=str2num(get(infmat(12,4),'string'));
 if any(abs([fir,las,len]-[las_fir,las_las,las_len])>0.01),
  set(bthan(1),'userdata',lomat);
  if infmat(9,1)==1, qnicplt(f);
  elseif infmat(9,1)==3,
   infmat(1,1:2)=[w(1),w(length(w))];
   infmat(2,1:2)=infmat(1,1:2);
   infmat(27,1:2)=infmat(1,1:2);
   set(infmat(24,1:2),'xlim',infmat(1,1:2));
   mgphplot(f);
  end
  set(bthan(16),'userdata',infmat);
 end
 if flag==2,
  set(bthan([1,8,29]),'enable','on');
  set(f2,'vis','off');
 else
  set(infmat(12,2),'string',num2str(w(1),3));
  set(infmat(12,3),'string',num2str(w(length(w)),3));
  set(infmat(12,4),'string',int2str(length(w)));
  set(h(3),'enable','off');
 end
end
