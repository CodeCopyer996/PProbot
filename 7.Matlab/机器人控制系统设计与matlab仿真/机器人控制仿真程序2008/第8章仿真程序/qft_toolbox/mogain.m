function mogain(flag,flag2)
% MOGAIN Mouse-implemented gain. (Utility Function)
%        MOGAIN determines the gain value to be added from various mouse
%        motions within the IDEs.

% Author: Craig Borghesani
% 9/5/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

f=gcf;
a=gca;
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
lomat=get(bthan(1),'userdata');
cont=get(bthan(3),'userdata');
hint_bar = get(bthan(36),'userdata');

w=lomat(1,:);
q=1; r=2;
if infmat(9,1)==2, q=[1;1]; r=2:3; end
lo=lomat(r,:);
T=get(bthan(13),'userdata');
am = infmat(24,1);
if infmat(9,1)==3, axs=infmat(2,3:4);
else axs=infmat(1,:); end
txt1 = infmat(30,1);
txt2 = infmat(30,2);

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
    set(f,'windowbuttonmotionfcn','mogain(1,1)',...
          'windowbuttonupfcn','mogain(1,2)');
    infmat(3,3)=kw;
    set(hint_bar,'string','Now, drag the frequency response to change the Gain');
   end
  elseif a==am,
   kw=qfindfrq(pt(1,1),pt(1,2),lomat,a);
   if length(kw),
    set(infmat(6,1),'xdata',w(kw),'ydata',20*log10(abs(lo(1,kw))),'vis','on');
    set(f,'windowbuttonmotionfcn','mogain(1,1)',...
          'windowbuttonupfcn','mogain(1,2)');
    infmat(3,3)=kw;
    set(hint_bar,'string','Now, drag the frequency response to change the Gain');
   end
  end
  set(bthan(16),'userdata',infmat);
 else
  set(f,'windowbuttonmotionfcn','mogain(1,1)',...
        'windowbuttonupfcn','mogain(1,2)');
  set(hint_bar,'string','Now, drag the frequency response to change the Gain');
 end
elseif flag2==1,
 kw=infmat(3,3);
 wval=w(kw);
 p=infmat(4,3);
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

% update pointer location text
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
  elseif any(infmat(9,1)==[2,3]),
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

  if all(pt(1,1:2)>infmat(1,[1,3]) & pt(1,1:2)<infmat(1,[2,4])),
   delk=10^((pt(1,2)-20*log10(abs(lo(1,kw))))/20);
   lo=lo*delk;
   cont(1,1)=delk*cont(1,1);
   lomat(r,:)=lo;

   if infmat(9,1)==1,
    set(infmat(6,1),'xdata',qfixfase(lo(1,:),axs,kw),...
                    'ydata',20*log10(abs(lo(1,kw))));
   else
    set(infmat(6,1),'xdata',w(kw),'ydata',20*log10(abs(lo(1,kw))));
   end

   set(bthan(1),'userdata',lomat);
   set(bthan(3),'userdata',cont);
   if infmat(9,1)==1, qnicplt(f);
   elseif infmat(9,1)==2, qmagplt(f);
   elseif infmat(9,1)==3, mgphplot(f);
   end
   set(hint_bar,'string','Gain change being implemented ...');
%   drawnow;
  else
   set(hint_bar,'string','Must remain within axis limits.');
  end
 end
elseif flag2==2,

 set(f,'windowbuttonmotionfcn','modisp','windowbuttondownfcn','',...
       'windowbuttonupfcn','');
 set(infmat(6,1),'userdata','mogain(1,0)');
 set(hint_bar,'string','To continue with EDIT of the Gain element re-select the marker');
 drawnow;

end
