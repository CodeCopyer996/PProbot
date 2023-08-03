function moldlg(flag,flag2)
% MOLDLG Mouse-implemented lead/lag element. (Utility Function)
%        MOLDLG determines the lead or lag value to be added from various
%        mouse motions within the IDEs.

% Author: Craig Borghesani
% 9/5/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

f=gcf;
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
lomat=get(bthan(1),'userdata');
cont=get(bthan(3),'userdata');
hint_bar = get(bthan(36),'userdata');

w=lomat(1,:);
q=1; r=2;
lo=lomat(r,:);
T=get(bthan(13),'userdata');
ap = infmat(24,2);
if infmat(9,1)==3, axs=infmat(2,3:4);
else axs=infmat(1,:); end
txt1 = infmat(30,1);
txt2 = infmat(30,2);
lcont = length(cont(:,1));

if flag2==0,
 if flag == 0,
  obj=get(f,'currentobject');
  p_obj=get(obj,'parent');
  if ~p_obj,
   a=get(f,'currentaxes');
  elseif p_obj==f,
   a=obj;
  else
   a=p_obj;
  end
  pt=get(a,'currentpoint');
  if infmat(9,1)==1,
   kw=qfindfrq(pt(1,1),pt(1,2),lomat,a);
   if length(kw),
    set(infmat(6,1),'xdata',qfixfase(lo,axs,kw),...
                    'ydata',20*log10(abs(lo(kw))),...
                    'vis','on');
    set(f,'windowbuttonmotionfcn',['moldlg(',int2str(lcont+1),',1)'],...
          'windowbuttonupfcn','moldlg(0,2)');
    set(hint_bar,'string','Now, drag the marker to ADD the Lead/Lag element based on phase difference');
    infmat(3,3)=kw;
   end
  elseif a==ap
   kw=qfindfrq(pt(1,1),pt(1,2),lomat,a,1);
   if length(kw),
    set(infmat(6,2),'xdata',w(kw),'ydata',qfixfase(lo(1,:),axs,kw),'vis','on');
    set(f,'windowbuttonmotionfcn',['moldlg(',int2str(lcont+1),',1)'],...
          'windowbuttonupfcn','moldlg(0,2)');
    infmat(3,3)=kw;
    set(hint_bar,'string','Now, drag the marker to ADD the Lead/Lag element based on phase difference');
   end
  end
  set(bthan(16),'userdata',infmat);
 else
  set(f,'windowbuttonmotionfcn',['moldlg(',int2str(lcont),',1)'],...
        'windowbuttonupfcn','moldlg(0,2)');
  set(hint_bar,'string','Now, drag the marker to EDIT the Lead/Lag element');
 end
elseif flag2==1,
 kw=infmat(3,3);
 wval=w(kw);
 p=infmat(4,3);
 ap = infmat(24,2);
 go_for_it=0;
 obj=get(f,'currentobject');
 p_obj=get(obj,'parent');
 if ~p_obj,
  a=get(f,'currentaxes');
 elseif p_obj==f,
  a=obj;
 else
  a=p_obj;
 end
 if (infmat(9,1)==1 | a==ap),
  pt=get(a,'currentpoint');
  if a==ap,
   delph=pt(1,2)-qfixfase(lo,axs,kw);
   magn = 20*log10(abs(lomat(2,kw)));
   phn = 180/pi*qatan4(lomat(2,kw));
   db_ol=sprintf('%0.2f',magn);
   ph_ol=sprintf('%0.2f',phn);
   mag=10^(magn/20);
   ph=pi/180*phn;
   ol=mag*exp(i*ph);
   db_cl=sprintf('%0.2f',20*log10(abs(ol/(1+ol))));
   ph_cl=sprintf('%0.2f',180/pi*qatan4(ol/(1+ol)));
   set(txt1,'string',[ph_ol,'deg,',db_ol,'dB']);
   set(txt2,'string',[ph_cl,'deg,',db_cl,'dB']);
   axislims = infmat(2,:);
  else
   delph=pt(1,1)-qfixfase(lo,axs,kw);
   db_ol=sprintf('%0.2f',pt(1,2));
   ph_ol=sprintf('%0.2f',pt(1,1));
   mag=10^(pt(1,2)/20);
   ph=pi/180*pt(1,1);
   ol=mag*exp(i*ph);
   db_cl=sprintf('%0.2f',20*log10(abs(ol/(1+ol))));
   ph_cl=sprintf('%0.2f',180/pi*qatan4(ol/(1+ol)));
   set(txt1,'string',[ph_ol,'deg,',db_ol,'dB']);
   set(txt2,'string',[ph_cl,'deg,',db_cl,'dB']);
   axislims = infmat(1,:);
  end
  if lcont~=flag,
   init_ph = 0;
  else
   init_ph = cont(flag,1);
  end
  if any(pt(1,1:2)<axislims([1,3]) | pt(1,1:2)>axislims([2,4])),
   go_for_it = 2;
  end
  if abs(init_ph+delph)>88, go_for_it = 1; end
  if ~go_for_it,
   if lcont~=flag,
    cp=lomat(3,:);
    cont=[cont;0,0,0,0];
   else
    cp=ldlgcplx(cont(flag,1),cont(flag,2),w,T);
   end
   cont(flag,1:4)=[cont(flag,1)+delph,wval,NaN,5];
   cpnv=ldlgcplx(cont(flag,1),cont(flag,2),w,T);
   lo=lo.*(cpnv./cp);
   lomat(r,:)=lo;
   if infmat(9,1)==1,
    set(infmat(6,1),'xdata',qfixfase(lo(1,:),axs,kw),...
                    'ydata',20*log10(abs(lo(1,kw))));
   else
    set(infmat(6,2),'xdata',w(kw),'ydata',qfixfase(lo(1,:),axs,kw));
   end
   infmat(4,3)=cpnv(kw);
   set(bthan(1),'userdata',lomat);
   set(bthan(3),'userdata',cont);
   set(bthan(16),'userdata',infmat);
   if infmat(9,1)==1, qnicplt(f);
   else mgphplot(f); end
   set(hint_bar,'string','Lead\Lag being implemented ...');
%   drawnow;
  elseif go_for_it == 1,
   set(hint_bar,'string','Phase difference must be > 0 and < 88 degrees.');
  elseif go_for_it == 2,
   set(hint_bar,'string','Must remain within axis limits.');
  end
 end

elseif flag2==2,

 set(f,'windowbuttonmotionfcn','modisp','windowbuttondownfcn','',...
       'windowbuttonupfcn','');
 set(infmat(6,1),'userdata',['moldlg(',int2str(lcont),',0)']);
 set(hint_bar,'string','To continue with EDIT of the Lead/Lag element re-select the marker');
 drawnow;

end
