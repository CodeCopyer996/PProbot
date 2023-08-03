function qmodlred(flag)
% QMODLRED Set up model reduction interface. (Utility Function)
%          QMODLRED performs a model reduction on the present controller.

% Author: Craig Borghesani
% 10/8/93
% Changes: Yossi Chait (from log-log freq weight to lin-lin)
% 10/28/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

if flag,
 f2=gcf;
 f=get(f2,'userdata');
else
 qclswin(0);
 f=gcf;
end
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
T=get(bthan(13),'userdata');
hint_bar = get(bthan(36),'userdata');
set(infmat(8,1),'enable','off');
proc_str=[];
if infmat(25,2)>1, proc_str=[' (',int2str(infmat(25,2)),')']; end
scrn=[640,480,640,480];

red = [1,0,0];
blue = [0,0,1];
cyan = [0,1,1];
dec = [];

fig_color=[0.5,0.5,0.5];
if flag==0 & (~length(T)),
 cont=get(bthan(3),'userdata');
 lomat=get(bthan(1),'userdata');
 set(bthan(27),'userdata',lomat);
 set(bthan(28),'userdata',cont);
 T=get(bthan(13),'userdata');
 [r,c]=size(cont);
 if r > 3+length(T),
  cntdisp(f,cont,2);
 else
  errordlg('No further reduction possible.','Message','on');
 end
elseif any(flag==[1,6]),
   set(bthan([1,8,29]),'enable','off');
   t=get(bthan(24),'userdata');
   cont=get(bthan(3),'userdata');
   T=get(bthan(13),'userdata');
   contmd=[]; go_for_it=1;
   for tv=1:length(t),
      vv_sty=get(t(tv),'style');
      vv_val=get(t(tv),'value');
      vv_vec(tv)=vv_val;
      if strcmp(vv_sty,'checkbox'),
         if vv_val,
            dec=[dec vv_val];
         end
      end
   end
   if length(dec) > 1,
      if any(cont(dec,4)==0.7),
         loc=find(vv_vec==2);
         val=str2num(get(t(loc+1),'string'));
         if length(val) & abs(val)<=abs(cont(2,1)),
            if cont(2,1)>0,
               contmd=[contmd;val,NaN,NaN,0.7];
               cont(2,1)=cont(2,1)-val;
            else
               contmd=[contmd;-val,NaN,NaN,0.7];
               cont(2,1)=cont(2,1)+val;
            end
         else
            errordlg('Improper input.  Check values','Message','on');
            go_for_it=0;
         end
         dec(find(dec==2))=[];
      end
      if any(cont(dec,4)==0.6),
         loc=find(vv_vec==3);
         val=str2num(get(t(loc+1),'string'));
         if length(val) & abs(val)<=abs(cont(3,1)),
            if cont(3,1)>0,
               contmd=[contmd;val,NaN,NaN,0.6];
               cont(3,1)=cont(3,1)-val;
            else
               contmd=[contmd;-val,NaN,NaN,0.6];
               cont(3,1)=cont(3,1)+val;
            end
         else
            errordlg('Improper input.  Check values','Message','on');
            go_for_it=0;
         end
         dec(find(dec==3))=[];
      end
      if any(cont(dec,4)==0.5),
         loc=find(vv_vec==2);
         val1=str2num(get(t(loc+1),'string'));
         val2=str2num(get(t(loc+3),'string'));
         if length([val1,val2])==2 & abs(val1)<=abs(cont(2,1)) ...
                             & abs(val2)<=abs(cont(2,2)),
            contmd=[contmd;val1,val2,NaN,0.6];
            cont(2,:)=cont(2,:)-[val1,val2];
         else
            errordlg('Improper input.  Check values','Message','on');
            go_for_it=0;
         end
         dec(find(dec==2))=[];
      end
      contmd=[contmd;cont(dec,:)];
      cont(dec,:)=[];
      contmd=[1,NaN,NaN,0;contmd];
      contmd=cntcvrt(contmd,T);
      dcgain=cntdcgn(contmd,T);
      contmd(1,1)=dcgain;
      [z,p,k]=cnt2zpk(contmd,T);
      [do_it,repeat] = chkzp(z,p,T);
      wfunc=[];
      if flag==6 & go_for_it & do_it,
         wfunc_han = get(bthan(26),'userdata');
         objects = get(wfunc_han(3),'userdata');
         obj_len = length(objects);
         if obj_len,
            ct = 1;
            y_scale = get(wfunc_han(11),'userdata');
            for k = 2:2:obj_len,
               if strcmp(get(objects(k),'vis'),'on'),
                  ydata = get(objects(k),'ydata');
                  ydata = ydata / max(ydata);
                  w = get(objects(k),'xdata');
                  a0 = ydata(1);
                  a1 = (ydata(2) - ydata(1))/(w(2)-w(1));
                  clr = get(objects(k),'userdata');
                  wtype = all(clr==blue)+all(clr==cyan)*2+all(clr==red)*3;
                  wfunc(ct,:) = [a0,a1,w(1),w(2),wtype];
                  ct = ct + 1;
               end
            end
            wfunc = [wfunc;0.001,0,0,inf,3];
         end
      end
      if go_for_it & do_it,
         if repeat,
            [sysb,hsv]=qfwbal(z,p,k,wfunc,'z');
         else
            [r,p,k]=qzp2rp(z,p,k);
            [sysb,hsv]=qfwbal(r,p,k,wfunc,'r');
         end
         if ~sysb,
            errordlg('Weight function needs more points','Message');
            return;
         end
         set(infmat(15,1),'vis','off');
         set(bthan(29),'userdata',sysb);
         set(bthan(30),'userdata',cont);
         set(hint_bar,'string','Plotting Hankel Singular Values');
         proc_num = int2str(infmat(25,2));
         win_tag = findobj('tag',['qft4',proc_num]);
         if ~length(win_tag),
            grey = [0.5,0.5,0.5];
            infmat(15,2) = colordef('new','none');
            set(infmat(15,2),'name',['Hankel Singular Values',proc_str],'numbertitle','off',...
                 'units','norm','pos',[20,20,360,250]./scrn,'vis','off','menubar','none',...
                 'userdata',f,'tag',['qft4',proc_num]);
            mod_scrn=[360,250,360,250];
            f2 = infmat(15,2);
            pos=get(gca,'pos');
            xticks = 0:length(hsv)+1;
            h(1)=gca;
            set(h(1),'pos',[pos+[0,0.1,0,-0.2]],'xtick',xticks,'yscale','log',...
            'ygrid','on','xgrid','on','box','on','nextplot','add',...
            'xlim',[0,length(hsv)+1],...
            'ylim',[10 .^[floor(log10(min(hsv))),ceil(log10(max(hsv)))]],...
            'color','k');
            h(2)=line('ydata',hsv,'xdata',[1:length(hsv)],'color','y','userdata',hsv);
            h(3)=line('ydata',hsv,'xdata',[1:length(hsv)],'color','r',...
                     'marker','x','userdata',[pos+[0,0.1,0,-0.2]],...
                     'linestyle','none');
            h(4)=uicontrol(f2,'style','text','units','norm','pos',[50,220,100,20]./mod_scrn,...
                   'string','Desired order:','back',grey);
            h(5)=uicontrol(f2,'style','edit','units','norm','pos',[150,220,50,20]./mod_scrn,...
                   'background',[1,1,1],'horiz','right');
            uicontrol(f2,'style','frame','units','norm','pos',[18,3,323,26]./mod_scrn,...
              'backgroundcolor',[0,0.5020,0]);
            h(6)=uicontrol(f2,'style','push','units','norm','pos',[21,6,60,20]./mod_scrn,...
                   'string','Apply','callback','qmodlred(2)');
            h(7)=uicontrol(f2,'style','push','units','norm','pos',[84,6,60,20]./mod_scrn,...
                   'string','Cancel','callback','qmodlred(5)');
            h(8)=uicontrol(f2,'style','push','units','norm','pos',[152,6,60,20]./mod_scrn,...
                   'string','Weight','callback','qwatecad(0)');
            h(9)=uicontrol(f2,'style','push','units','norm','pos',[215,6,60,20]./mod_scrn,...
                   'string','Select','callback','qmodlred(4)');
            h(10)=uicontrol(f2,'style','push','units','norm','pos',[278,6,60,20]./mod_scrn,...
                   'string','Done','callback','qmodlred(3)');
            set(bthan(25),'userdata',h);
            h2 = uimenu('label','Line','enable','off');
            h2_sub(1)=uimenu(h2,'label','Add Line',...
            'callback',...
            'set(gcf,''pointer'',''crosshair'',''windowbuttonupfcn'',''qaddobj(0)'',''windowbuttondownfcn'','''',''windowbuttonmotionfcn'','''')');

            h2_sub(2)=uimenu(h2,'label','Add Point',...
                     'callback',...
               'set(gcf,''pointer'',''crosshair'',''windowbuttonupfcn'',''qedtobj(0)'',''windowbuttondownfcn'','''',''windowbuttonmotionfcn'','''')');

            h2_sub(3)=uimenu(h2,'label','Move',...
               'callback',...
               'qbtnkill;set(gcf,''pointer'',''fleur'',''windowbuttondownfcn'',''set(gca,''''userdata'''',get(gca,''''currentpoint''''));set(gcf,''''windowbuttonmotionfcn'''',''''qmoveobj'''')'')');
            h2_sub(4)=uimenu(h2,'label','Delete','callback','qdelobj(0)');
            h2_sub(5)=uimenu(h2,'label','Break','callback','qdelobj(1)');
            h2_sub(6)=uimenu(h2,'label','Connect','callback','qdelobj(2)');
            h2_sub(7)=uimenu(h2,'label','Type');
            uimenu(h2_sub(7),'label','Input','callback','qdelobj(6)');
            uimenu(h2_sub(7),'label','Output','callback','qdelobj(7)');
            uimenu(h2_sub(7),'label','Both','callback','qdelobj(8)');
            h2_sub(8)=uimenu(h2,'label','Select');
            uimenu(h2_sub(8),'label','All','callback','qdelobj(5)');
            uimenu(h2_sub(8),'label','None','callback','qdelobj(4)');
            set(h2_sub(2:8),'enable','off');
            o=uimenu('label','Options','enable','off');
            o_sub(1)=uimenu(o,'label','Full','callback','qzoomaxs(3)');
            o_sub(2)=uimenu(o,'label','Zoom','callback','qzoomaxs(0)');
            o_sub(3)=uimenu(o,'label','Clear','callback','qdelobj(3)');
            o_sub(4)=uimenu(o,'label','Open...','callback','qputobj(0)',...
                      'separator','on');
            o_sub(5)=uimenu(o,'label','Save...','callback','qputobj(1)');
            han = [infmat(15,2),h(1),h2,h2_sub,o,o_sub];
            set(bthan(26),'userdata',han);
            set(infmat(15,2),'vis','on');
            set(bthan(16),'userdata',infmat);
         else
            set(f2,'pointer','arrow','windowbuttondownfcn','',...
           'windowbuttonupfcn','','windowbuttonmotionfcn','',...
           'name',['Hankel Singular Values',proc_str]);
            h = get(bthan(25),'userdata');
            h2 = get(bthan(26),'userdata');
            set(h2([3,12]),'enable','off');
            set(get(h2(3),'userdata'),'color',[0,0,0]);
            pos=get(h(3),'userdata');
            xticks = 0:length(hsv)+1;
            set(h(1),'pos',pos,'xtick',xticks,'xlim',[0,length(hsv)+1],...
             'ylim',[10 .^[floor(log10(min(hsv))),ceil(log10(max(hsv)))]],'yscale','log','xscale','linear');
            set(h(2),'ydata',hsv,'xdata',1:length(hsv));
            set(h(3),'ydata',hsv,'xdata',1:length(hsv),'vis','on');
            set(h(5),'string','');
            set(h([4,5,8,9,10]),'vis','on');
            set(h(6),'callback','qmodlred(2)');
            set(h(7),'callback','qmodlred(5)');
            figure(infmat(15,2));
         end
      end
   elseif length(dec)==1,
      errordlg('No further reduction possible.','Message','on');
   else
      errordlg('You must select something','Message','on');
   end

elseif flag==2, % Reduce
 T=get(bthan(13),'userdata');
 lomat=get(bthan(1),'userdata');
 cont=get(bthan(3),'userdata');
 delay=infmat(10,1);
 q=1; s=0;
 if infmat(9,1)==2, q=[1;1]; s=1; end
 loc=qcntbode(cont,lomat(1,:),T).*exp(-i*lomat(1,:)*delay);
 sysb=get(bthan(29),'userdata');
 [sr,sc] = size(sysb);
 cont=get(bthan(30),'userdata');
 mis_han = get(bthan(25),'userdata');
 val=str2num(get(mis_han(5),'string'));
 if val>0 & val<=(sc-2) & (~rem(val,1)),
  set(hint_bar,'string','Performing model order reduction');
  ar = sysb(1:val,1:val);
  br = sysb(1:val,sc-1);
  cr = sysb(sr-1,1:val);
  dr = sysb(sr-1,sc-1);
  [z,p]=ss2zp(ar,br,cr,dr);
  contmd=zp2cnt(z,p,cont,T);
  locmd=qcntbode(contmd,lomat(1,:),T).*exp(-i*lomat(1,:)*delay);
  lomat(2:2+s,:)=lomat(2:2+s,:).*(locmd(q,:)./loc(q,:));
  set(bthan(20),'userdata',lomat);
  set(bthan(19),'userdata',contmd);
  if infmat(9,1)==1, qnicplt(f);
  elseif infmat(9,1)==2, qmagplt(f);
  elseif infmat(9,1)==3, mgphplot(f);
  end
  cont=contmd;
  cntdisp(f,cont,5);
  figure(infmat(15,2));
 else
  errordlg('Improper input.  Check values.','Message','on');
 end
elseif flag==3, % Done
 contmd=get(bthan(19),'userdata');
 lomatnv=get(bthan(20),'userdata');
 if length(lomatnv),
  set(bthan(1),'userdata',lomatnv);
  set(bthan(3),'userdata',contmd);
  set(bthan([19:20,30]),'userdata',[]);
  v=get(bthan(10),'userdata');
  v2=get(bthan(21),'userdata');
  if infmat(9,1)==1,
   vo2=get(bthan(22),'userdata');
   vo=get(bthan(17),'userdata');
   set([v,vo],'vis','off');
   set(bthan(22),'userdata',vo);
   set(bthan(17),'userdata',vo2);
  else
   set(v,'vis','off');
  end
  set(v2,'linestyle','-');
  set(v,'linestyle','--');
  set(bthan(10),'userdata',v2);
  set(bthan(21),'userdata',v);
  set(infmat(8,1),'enable','on');
 end
 han2 = get(bthan(26),'userdata');
 w_func = get(han2(3),'userdata');
 delete(w_func);
 set(han2(3),'userdata',[]);
 set(bthan([1,8,29]),'enable','on');
 qclswin(1);
elseif flag==4, % Select
 set(bthan([1,8,29]),'enable','on');
 cont=get(bthan(3),'userdata');
 set(infmat(15,2),'vis','off');
 v2=get(bthan(21),'userdata');
 vo2=get(bthan(22),'userdata');
 set([v2,vo2],'vis','off');
 set(bthan([19:20,30]),'userdata',[]);
 cntdisp(f,cont,9);
elseif flag==5, % Cancel
 set(bthan([1,8,29]),'enable','on');
 v2=get(bthan(21),'userdata');
 vo2=get(bthan(22),'userdata');
 if infmat(9,1)==1,
  set([v2(:);vo2(:)],'vis','off');
 else
  set(v2,'vis','off');
 end
 set(bthan([19:20,30]),'userdata',[]);
 han2 = get(bthan(26),'userdata');
 w_func = get(han2(3),'userdata');
 delete(w_func);
 set(han2(3),'userdata',[]);
 qclswin(1);
elseif flag == 7, % Cancel from controller display window
 set(bthan([1,8,29]),'enable','on');
 set(f2,'vis','off');
else
 errordlg('Currently not avaliable for Discrete','Message','on');
end
