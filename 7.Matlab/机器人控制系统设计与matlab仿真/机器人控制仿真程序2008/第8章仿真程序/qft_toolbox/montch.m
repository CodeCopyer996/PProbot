function montch(flag,flag2)
% MONTCH Mouse-implemented notch element. (Utility Function)
%        MONTCH determines the notch value to be added from various
%        mouse motions within the IDEs.


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
lo=lomat(r,:);
T=get(bthan(13),'userdata');
delay=infmat(10,1);
am = infmat(24,1);
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
    set(f,'windowbuttonmotionfcn',['montch(',int2str(lcont+1),',1)'],...
          'windowbuttonupfcn','montch(0,2)');
    set(hint_bar,'string','Now, drag the marker to ADD the Notch element based on mag difference');
    infmat(3,3)=kw;
   end
  else
   kw=qfindfrq(pt(1,1),pt(1,2),lomat,a);
   if length(kw),
    set(infmat(6,1),'xdata',w(kw),'ydata',20*log10(abs(lo(1,kw))),'vis','on');
    set(f,'windowbuttonmotionfcn',['montch(',int2str(lcont+1),',1)'],...
          'windowbuttonupfcn','montch(0,2)');
    set(hint_bar,'string','Now, drag the marker to ADD the Notch element based on mag difference');
    infmat(3,3)=kw;
   end
  end
  set(bthan(16),'userdata',infmat);
 else
  set(f,'windowbuttonmotionfcn',['montch(',int2str(lcont),',1)'],...
        'windowbuttonupfcn','montch(0,2)');
  set(hint_bar,'string','Now, drag the marker to EDIT the Notch element');
 end
elseif flag2==1,
 kw=infmat(3,3);
 wval=w(kw);
 p=infmat(4,3);
 am = infmat(24,1);
 obj=get(f,'currentobject');
 p_obj=get(obj,'parent');
 if ~p_obj,
  a=get(f,'currentaxes');
 elseif p_obj==f,
  a=obj;
 else
  a=p_obj;
 end
 if a==am,
  pt=get(a,'currentpoint');
  if infmat(9,1)==1,
   db_ol=sprintf('%0.2f',pt(1,2));
   ph_ol=sprintf('%0.2f',pt(1,1));
   mag=10^(pt(1,2)/20);
   ph=pi/180*pt(1,1);
   ol=mag*exp(i*ph);
   db_cl=sprintf('%0.2f',20*log10(abs(ol/(1+ol))));
   ph_cl=sprintf('%0.2f',180/pi*qatan4(ol/(1+ol)));
   set(txt1,'string',[ph_ol,'deg,',db_ol,'dB']);
   set(txt2,'string',[ph_cl,'deg,',db_cl,'dB']);
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
  end
  axislims = infmat(1,:);
  if p~=0,
   delmag=abs(p)*10^(pt(1,2)/20)/abs(lomat(2,kw));
  else
   delmag=10^(pt(1,2)/20)/abs(lomat(2,kw));
  end
  if all(pt(1,1:2)>axislims([1,3]) & pt(1,1:2)<axislims([2,4])),
   if lcont~=flag,  % adding with the mouse
    if delmag>1, zeta(1)=0.5; zeta(2)=zeta(1)/delmag;
    else zeta(2)=0.5; zeta(1)=zeta(2)*delmag; end
    cont=[cont;0,0,0,0];
    cont(flag,1:4)=[zeta(1),zeta(2),wval,6];
    if length(nom) & infmat(9,1)~=2,
     wlt=qfrqenh(wval,zeta(1+(zeta(1)>zeta(2))),w,T);
     [ncon,dcon]=cntextr(cont,T);
     if infmat(9,1)~=3,
      nlot=qcpqft(nom(1,:),nom(2,:),wlt,T);
      clot=qcntbode(cont,wlt,T).*exp(-i*wlt*delay);
      lot=nlot.*clot;
     else
      lot=qcntbode(cont,wlt,T).*exp(-i*wlt*delay);
     end
     lomat=[wlt;lot;ones(1,length(lot))];
     cpnv=ntchcplx(zeta(1),zeta(2),wval,lomat(1,:),T);
    else
     cpnv=ntchcplx(zeta(1),zeta(2),wval,w,T);
     lomat(r,:)=lomat(r,:).*cpnv(q,:);
    end
   else  % iterating with the mouse or continuation of adding
    zeta=cont(flag,1:2);
    if delmag>1, zeta(1)=0.5; zeta(2)=zeta(1)/delmag;
    else zeta(2)=0.5; zeta(1)=zeta(2)*delmag; end
    cp=ntchcplx(cont(flag,1),cont(flag,2),wval,w,T);
    cont(flag,1:4)=[zeta(1),zeta(2),wval,6];
    cpnv=ntchcplx(zeta(1),zeta(2),wval,w,T);
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
   end
   infmat(3,3)=kw;
   infmat(4,3)=cpnv(kw);
   set(bthan(1),'userdata',lomat);
   set(bthan(3),'userdata',cont);
   set(bthan(16),'userdata',infmat);
   if infmat(9,1)==1, qnicplt(f);
   elseif infmat(9,1)==2, qmagplt(f);
   elseif infmat(9,1)==3, mgphplot(f);
   end
   set(hint_bar,'string','Notch element being implemented ...');
%   drawnow;
  else
   set(hint_bar,'string','Must remain within axis limits');
  end
 end

elseif flag2==2,

 set(f,'windowbuttonmotionfcn','modisp','windowbuttondownfcn','',...
       'windowbuttonupfcn','');
 set(infmat(6,1),'userdata',['montch(',int2str(lcont),',0)']);
 set(hint_bar,'string','To continue with EDIT of the Notch element re-select the marker');
 drawnow;

end
