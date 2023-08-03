function cntopen(flag)
% CNTOPEN Open controller file. (Utility Function)
%         CNTOPEN allows the user to open a saved controller matrix.

% Author: Craig Borghesani
% 9/6/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

f=gcf;
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');

old_cont=get(bthan(3),'userdata');
old_lomat=get(bthan(1),'userdata');
hint_bar = get(bthan(36),'userdata');

set(bthan(27),'userdata',old_lomat);
set(bthan(28),'userdata',old_cont);
set(infmat(8,1),'enable','on');
lomat=get(bthan(1),'userdata');

T=get(bthan(13),'userdata');
last_name = get(bthan(15),'userdata');
flag2=infmat(9,1)*2-(length(T)==0);

if flag==1,
 proc_str=[];
 if infmat(25,2)>1, proc_str=['(',int2str(infmat(25,2)),')']; end

 str=str2mat('*.shp','*.dsh','*.fsh','*.dfs','*.bod','*.dbo');
 file_name = str(flag2,:);

 str2=str2mat(['Open Controller File ',proc_str],...
              ['Open Filter File ',proc_str],...
              ['Open Loop File ',proc_str]);

 [fname,pth]=uigetfile(file_name,str2(infmat(9,1),:));

else

 pth = '';
 if flag2==1, fname='shape.shp';
 elseif flag2==2, fname='dshape.dsh';
 elseif flag2==3, fname='fshape.fsh';
 elseif flag2==4, fname='dfshape.dfs';
 elseif flag2==5, fname='bodplot.bod';
 elseif flag2==6, fname='dbodplot.dbo';
 end

 if ~exist(fname),
  errordlg(['Quick Open could not find <',fname,'>'],'Message','on');
  fname = 0;
 end

end

q=1;
if infmat(9,1)==2, q=[1;1]; end

if isstr(fname),
 set(bthan(15),'userdata',fname);
 qclswin(0);
 eval(['load ''',pth,fname,''' -mat']);
 wl=lomat(1,:); nom=get(bthan(2),'userdata');
 delay=infmat(10,1);
 T2=T;
 T=get(bthan(13),'userdata');
 go_for_it=1;
 if length(T) & length(T2),
  if T~=T2,
   go_for_it=2;
  end
 elseif ~length(T2) & length(T),
  go_for_it=3;
 elseif ~length(T) & length(T2),
  go_for_it=4;
 end

 if go_for_it==1,
  cp=qcntbode(cont_r,wl,T);
  if length(nom) & infmat(9,1)==1,
   ncp=qcpqft(nom(1,:),nom(2,:),wl,T).*exp(-i*delay*wl);
  elseif infmat(9,1)==1,
   conL0=get(bthan(4),'userdata');
   L0=get(bthan(8),'userdata');
   cp0=qcntbode(conL0,wl,T); ncp=L0./cp0;
  elseif infmat(9,1)==2,
   ncp=get(bthan(17),'userdata');
  elseif infmat(9,1)==3,
   if length(nom),
    ncp=ones(1,length(wl));
   else
    ncp=get(bthan(8),'userdata');
   end
  end
  lomat(2:2+(infmat(9,1)==2),:)=cp(q,:).*ncp;
  set(bthan(3),'userdata',cont_r);
  set(bthan(1),'userdata',lomat);
  if infmat(9,1)==1, qnicplt(f);
  elseif infmat(9,1)==2, qmagplt(f);
  elseif infmat(9,1)==3, mgphplot(f);
  end
  set(hint_bar,'string',['Opening <',pth,fname,'>...']);
 elseif go_for_it==2,
  if infmat(9,1)==1,
   errordlg(['Sampling time mismatch. Controller (',num2str(T2),') Environment (',num2str(T),')'],'Message','on');
  elseif infmat(9,1)==2,
   errordlg(['Sampling time mismatch. Pre-filter (',num2str(T2),') Environment (',num2str(T),')'],'Message','on');
  end
 elseif go_for_it==3,
  if infmat(9,1)==1,
   errordlg('Continuous-time controller cannot be used in DLPSHAPE','Message','on');
  elseif infmat(9,1)==2,
   errordlg('Continuous-time pre-filter cannot be used in DPFSHAPE','Message','on');
  end
 elseif go_for_it==4,
  if infmat(9,1)==1,
   errordlg('Discrete-time controller cannot be used in LPSHAPE','Message','on');
  elseif infmat(9,1)==2,
   errordlg('Discrete-time pre-filter cannot be used in PFSHAPE','Message','on');
  end
 end
end
