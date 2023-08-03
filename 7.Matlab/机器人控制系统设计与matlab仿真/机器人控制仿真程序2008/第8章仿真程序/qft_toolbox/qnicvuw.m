function qnicvuw(flag)
% QNICVUW View functions for LPSHAPE/DLPSHAPE. (Utility Function)
%         QNICVUW executes the various view commands: Full, In, Out, Move,
%         Zoom, Axis, Stability for the CAD environments LPSHAPE/DLPSHAPE.

% Author: Craig Borghesani
% 8/31/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

f=gcf; a=gca;
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
lomat=get(bthan(1),'userdata');
lomat2=get(bthan(20),'userdata');
hint_bar = get(bthan(36),'userdata');
w=lomat(1,:); lo=lomat(2,:);
lo2 = [];
if length(lomat2), lo2=lomat2(2,:); end;
cont=get(bthan(3),'userdata');
nom=get(bthan(2),'userdata');
axs=infmat(1,:);
bdaxs=infmat(2,:);
T=get(bthan(13),'userdata');
delay=infmat(10,1);
proc_num = int2str(infmat(25,2));

cont2 = get(bthan(31),'userdata');
if length(cont2),
 cont(1,1) = cont(1,1)*cont2(1,1);
 if length(T),
  cont(3,1) = cont(3,1)+cont2(3,1);
  cont2(1:3,:) = [];
 else
  cont2(1:2,:) = [];
 end
 cont = [cont;cont2];
end

fig_color=[0.5,0.5,0.5];

if flag==1, % Full
 infmat(26,:)=axs;
 axs(1:2)=infmat(27,1:2);
 axs(3)=min([min(20*log10(abs([lo,lo2]))),bdaxs(3)])-5;
 axs(4)=max([max(20*log10(abs([lo,lo2]))),bdaxs(4)])+5;
elseif flag==2, % In
 infmat(26,:)=axs;
 amt=(axs(4)-axs(3))*0.2; axs=axs+[0 0 amt -amt];
elseif flag==3, % Out
 infmat(26,:)=axs;
 amt=(axs(4)-axs(3))*0.2; axs=axs+[0 0 -amt amt];
elseif flag==4, % Last
 tempaxs=axs;
 axs=infmat(26,:);
 infmat(26,:)=tempaxs;
elseif flag==11, % Move-initialization
 set(f,'pointer','crosshair','windowbuttonmotionfcn','');
 set(f,'windowbuttondownfcn','qnicvuw(10)');
elseif flag==10, % Move-getting first point
 pt=get(a,'currentpoint');
 set(f,'windowbuttondownfcn','qnicvuw(5)');
 set(a,'userdata',pt);
elseif flag==5, % Move-getting second point and setting new axis limits
 pt2=get(a,'currentpoint'); pt = get(a,'userdata');
 delx=pt2(1,1)-pt(1,1); dely=pt2(1,2)-pt(1,2);
 infmat(26,:)=axs;
 axs=[axs(1:2)+delx,axs(3:4)+dely];
elseif flag==13, % Zoom-initialization
 set(f,'pointer','crosshair','windowbuttonmotionfcn','');
 set(f,'windowbuttondownfcn','qnicvuw(6)','windowbuttonupfcn','1;');
elseif flag==6, % Zoom
 pt0=get(a,'currentpoint');
 rbbox([get(f,'currentpoint'),0,0],get(f,'currentpoint'));
 drawnow;
 pt1=get(a,'currentpoint');
 minx=min([pt0(1,1),pt1(1,1)]); miny=min([pt0(1,2),pt1(1,2)]);
 maxx=max([pt0(1,1),pt1(1,1)]); maxy=max([pt0(1,2),pt1(1,2)]);
 minx=max([minx,axs(1)]); miny=max([miny,axs(3)]);
 maxx=min([maxx,axs(2)]); maxy=min([maxy,axs(4)]);
 infmat(26,:)=axs;
 axs=[minx,maxx,miny,maxy];
 set(f,'windowbuttonupfcn','');
elseif flag==8, % Stability
 [zc,pc,kc]=cnt2zpk(cont,T);
 np=nom(1,:); dp=nom(2,:);
 if exist('zp2ss'),
  if (length(pc) >= length(zc)) & ((length(np)-1) >= (length(dp)-1)),
   [ac,bc,cc,dc]=zp2ss(zc,pc,kc);
   [ap,bp,cp,dp]=tf2ss(np,dp);
   if chkstab(ap,bp,cp,dp,ac,bc,cc,dc,T),
    errordlg('Nominal System Stability Failed','Message','on');
   else
    errordlg('Nominal System Stability Passed','Message','on');
   end
  else
   errordlg('Irrational Nominal System','Message','on');
  end
 else
  errordlg('Control System Toolbox needed for this option','Message','on');
 end
elseif flag==9, % Elements
 cntdisp(f,cont,5);
elseif flag==14,
 nom_plant = cntpars(nom(1,:),nom(2,:),T);
 cntdisp(f,nom_plant,5,'Plant');
elseif flag==15, % Refresh
 v1 = get(bthan(10),'userdata'); v2 = get(bthan(17),'userdata');
 v3 = get(bthan(21),'userdata'); v4 = get(bthan(22),'userdata');
 init_vis = get(v3(1),'vis');
 set([v1,v2,v3,v4],'vis','off');
 set(f,'color','k');
 set(a,'vis','off');
 drawnow;
 set(a,'vis','on');
 set([v1,v2],'vis','on');
 set([v3,v4],'vis',init_vis);
end
if any(flag==[1:7]),
 set(f,'windowbuttonmotionfcn','modisp','windowbuttonupfcn','',...
       'windowbuttondownfcn','');
 if diff(axs(1:2)) <= 0 | diff(axs(3:4)) <= 0,
  set(hint_bar,'string','Invalid region selected.  Please try again.');
 else
  set(a,'xlim',axs(1:2),'ylim',axs(3:4));
  infmat(1,:)=axs; set(bthan(16),'userdata',infmat);
  qnicplt(f);
  if flag==5,
   copybnds(f);
  end
  set(hint_bar,'string','Ready');
 end
 if length(findobj('tag',['qft3',proc_num])),
  if strcmp(get(infmat(15,1),'vis'),'on'),
   figure(infmat(15,1));
  end
 end
 if length(findobj('tag',['qft4',proc_num])),
  if strcmp(get(infmat(15,2),'vis'),'on'),
   figure(infmat(15,2));
  end
 end
 if length(findobj('tag',['qft1',proc_num])),
  if strcmp(get(infmat(14,1),'vis'),'on'),
   figure(infmat(14,1));
  end
 end
end
