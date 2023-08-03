function mosecond(flag,flag2)
% MOSECNOD Mouse-implemented second order element. (Utility Function)
%          MOSECNOD determines the second order value to be added from
%          various mouse motions within the IDEs.

% Author: Craig Borghesani
% 9/5/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

f=gcf;
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
lomat=get(bthan(1),'userdata');
nom=get(bthan(2),'userdata');
cont=get(bthan(3),'userdata');
hint_bar = get(bthan(36),'userdata');

w=lomat(1,:);
q=1; r=2;
if infmat(9,1)==2, q=[1;1]; r=2:3; end
T=get(bthan(13),'userdata');
delay=infmat(10,1);
if infmat(9,1)==3, axs=infmat(2,3:4);
else axs=infmat(1,:); end
am = infmat(24,1);
ap = infmat(24,2);
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
    set(infmat(6,1),'xdata',qfixfase(lomat(2,:),axs,kw),...
                    'ydata',20*log10(abs(lomat(2,kw))),...
                    'vis','on');
   end
  elseif infmat(9,1)==2,
   kw=qfindfrq(pt(1,1),pt(1,2),lomat,a);
   if length(kw),
    set(infmat(6,1),'xdata',w(kw),'ydata',20*log10(abs(lomat(2,kw))),'vis','on');
   end
  elseif infmat(9,1)==3,
   if a==am,
    kw=qfindfrq(pt(1,1),pt(1,2),lomat,a);
   elseif a==ap,
    kw=qfindfrq(pt(1,1),pt(1,2),lomat,a,1);
   end
   if length(kw),
    set(infmat(6,1),'xdata',w(kw),'ydata',20*log10(abs(lomat(2,kw))),'vis','on');
    set(infmat(6,2),'xdata',w(kw),'ydata',qfixfase(lomat(2,:),axs,kw),'vis','on');
   end
  end
  if length(kw),
   lomat(3+(infmat(9,1)==2),:)=lomat(2,:);
   infmat(3,3)=kw;
   infmat(4,3)=lomat(2,kw);
   set(f,'windowbuttonmotionfcn',['mosecond(',int2str(lcont+1),',1)'],...
         'windowbuttonupfcn','mosecond(0,2)');
   if a==am & infmat(9,1)==1,
    set(hint_bar,'string','Now, drag the marker to ADD the Second Order element based on mag and phase differences');
   elseif a==am,
    set(hint_bar,'string','Now, drag the marker to ADD the Second Order element based on mag difference');
   else
    set(hint_bar,'string','Now, drag the marker to ADD the Second Order element based on phase difference');
   end
   set(bthan(1),'userdata',lomat);
   set(bthan(16),'userdata',infmat);
  end
 else
  set(f,'windowbuttonmotionfcn',['mosecond(',int2str(lcont),',1)'],...
        'windowbuttonupfcn','mosecond(0,2)');
  set(hint_bar,'string','Now, drag the marker to EDIT the Second Order element');
 end
elseif flag2==1,
 kw=infmat(3,3);
 wval=w(kw);
 p=infmat(4,3);
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
 pt=get(a,'currentpoint');
 if infmat(9,1)==1,
  delmag=10^(pt(1,2)/20)/abs(p);
  delph=pt(1,1)-qfixfase(lomat(3,:),axs,kw);
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
 else
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
  if a==ap,
   delph=pt(1,2)-qfixfase(lomat(3,:),axs,kw);
   axislims = infmat(2,:);
  elseif a==am,
   delmag=10^(pt(1,2)/20)/abs(p);
   axislims = infmat(1,:);
  end
 end
 if infmat(9,1)==1,
  if abs(delph)<176 & delph~=0,
   delval=delph;
   val=0;
   if length(T), [zta,wn,state]=dsecond(delph,delmag,wval,T);
   else [zta,wn,state]=csecond(delph,delmag,wval); end
   if any(state==[1,2]), go_for_it=1; end
  else go_for_it = 2; end
 elseif infmat(9,1)==2,
  delval=delmag;
  if delmag > 1, delmag = 1/delmag; end
  [zta,wn,state]=csecond(0,delmag,wval);
  val=1;
 elseif infmat(9,1)==3,
  if a==ap,
   if abs(delph)<176 & delph~=0,
    [zta,wn,state]=csecond(delph,0,wval);
    delval=delph;
    val=0;
   else go_for_it = 2; end
  else
   delval=delmag;
   if delmag > 1, delmag = 1/delmag; end
   [zta,wn,state]=csecond(0,delmag,wval);
   val=1;
  end
 end
 if any(pt(1,1:2)<axislims([1,3]) | pt(1,1:2)>axislims([2,4])),
  go_for_it = 3;
 end
 if ~go_for_it,
  if lcont~=flag,  % adding with the mouse
   cont=[cont;0,0,0,0];
   cont(flag,1:4)=[zta,wn,NaN,3*(delval<val)+4*(delval>val)];
   if length(nom) & zta<1 & infmat(9,1)~=2,
    wlt=qfrqenh(wn,zta,w,T);
    if infmat(9,1)~=3,
     nlot=qcpqft(nom(1,:),nom(2,:),wlt,T);
     clot=qcntbode(cont,wlt,T).*exp(-i*wlt*delay);
     lot=nlot.*clot;
     lot2=lot./qcntbode(cont(flag,:),wlt,T);
    else
     lot=qcntbode(cont,wlt,T).*exp(-i*wlt*delay);
     lot2=lot./qcntbode(cont(flag,:),wlt,T);
    end
    lomat=[wlt;lot;lot2];
   else
    cpnv=cproot(zta,wn,w,[(cont(flag,4)==4)-(cont(flag,4)==3),T]);
    lomat(r,:)=lomat(r,:).*cpnv(q,:);
   end
  else  % iterating with the mouse or continuation of adding
   cp=cproot(cont(flag,1),cont(flag,2),w,[(cont(flag,4)==4)-(cont(flag,4)==3),T]);
   cont(flag,1:4)=[zta,wn,NaN,3*(delval<val)+4*(delval>val)];
   cpnv=cproot(zta,wn,w,[(cont(flag,4)==4)-(cont(flag,4)==3),T]);
   lomat(r,:)=lomat(r,:).*(cpnv(q,:)./cp(q,:));
  end
  kw=find(lomat(1,:)>=w(kw)); kw=kw(1);
  if infmat(9,1)==1,
   set(infmat(6,1),'xdata',qfixfase(lomat(2,:),axs,kw),...
                   'ydata',20*log10(abs(lomat(2,kw))));
  elseif infmat(9,1)==2,
   set(infmat(6,1),'xdata',w(kw),'ydata',20*log10(abs(lomat(2,kw))));
  elseif infmat(9,1)==3,
   set(infmat(6,1),'xdata',lomat(1,kw),'ydata',20*log10(abs(lomat(2,kw))));
   set(infmat(6,2),'xdata',lomat(1,kw),'ydata',qfixfase(lomat(2,:),axs,kw));
  end
  infmat(3,3)=kw;
  infmat(4,3)=lomat(3+(infmat(9,1)==2),kw);
  set(bthan(1),'userdata',lomat);
  set(bthan(3),'userdata',cont);
  set(bthan(16),'userdata',infmat);
  if infmat(9,1)==1, qnicplt(f);
  elseif infmat(9,1)==2, qmagplt(f);
  elseif infmat(9,1)==3, mgphplot(f);
  end
  set(hint_bar,'string','Second Order being implemented ...');
%  drawnow;
 elseif go_for_it == 1,
  set(hint_bar,'string','Implementation not possible.');
 elseif go_for_it == 2,
  set(hint_bar,'string','Phase difference must be > 0 and < 176 degrees.');
 elseif go_for_it == 3,
  set(hint_bar,'string','Must remain within axis limits.');
 end

elseif flag2==2,

 set(f,'windowbuttonmotionfcn','modisp','windowbuttondownfcn','',...
       'windowbuttonupfcn','');
 set(infmat(6,1),'userdata',['mosecond(',int2str(lcont),',0)']);
 set(hint_bar,'string','To continue with EDIT of the Second Order element re-select the marker');
 drawnow;

end
