function qnicplt(f)
% QNICPLT Plot nichols response. (Utility Function)
%         QNICPLT plots the magnitude and phase response for the CAD
%         environments LPSHAPE/DLPSHAPE

% Author: Craig Borghesani
% 8/31/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
lomat=get(bthan(1),'userdata');
lomat2=get(bthan(20),'userdata');
wbs=get(bthan(11),'userdata');
axs=infmat(1,:);
vax = infmat(23,1);

if ~length(lomat2),
 w=lomat(1,:); lo=lomat(2,:);
 db=20*log10(abs(lo));
 ph=qfixfase(lo,axs);
 v=get(bthan(10),'userdata');
 vo=get(bthan(17),'userdata');
 brk=find(abs(diff(ph))>170);
 t=1; pht=[]; dbt=[]; wt=[];
 for k=brk,
  pht=[pht,ph(t:k),NaN];
  dbt=[dbt,db(t:k),NaN];
  wt=[wt,w(t:k),NaN];
  t=k+1;
 end
 pht=[pht,ph(t:length(ph))];
 dbt=[dbt,db(t:length(db))];
 wt=[wt,w(t:length(w))];

 if ~vax,
  rmv_pt=find(dbt>axs(4) | dbt<axs(3) | pht>axs(2) | pht<axs(1));
  pht(rmv_pt)=pht(rmv_pt)+NaN;
  dbt(rmv_pt)=dbt(rmv_pt)+NaN;
 end

 set(v,'xdata',pht,'ydata',dbt);
 set(v,'vis','on');

 if length(wbs),
  for j=1:length(wbs),
   q=find(wt>=wbs(j) & ~isnan(wt));  q2=find(wt<=wbs(j) & ~isnan(wt));
   if ~length(q) | ~length(q2), loc(j)=NaN; else loc(j)=q(1); end
  end
  for j=1:length(wbs),
   if ~isnan(loc(j)),
    set(vo(j),'xdata',pht(loc(j)),'ydata',dbt(loc(j)));
    set(vo(j),'vis','on');
   end
  end
 end
else
 w=lomat2(1,:); lo=lomat2(2,:);
 db=20*log10(abs(lo));
 ph=qfixfase(lo,axs);
 v=get(bthan(21),'userdata');
 vo=get(bthan(22),'userdata');
 brk=find(abs(diff(ph))>100);
 t=1; pht=[]; dbt=[]; wt=[];
 for k=brk,
  pht=[pht,ph(t:k),NaN];
  dbt=[dbt,db(t:k),NaN];
  wt=[wt,w(t:k),NaN];
  t=k+1;
 end
 pht=[pht,ph(t:length(ph))];
 dbt=[dbt,db(t:length(db))];
 wt=[wt,w(t:length(w))];

 if ~vax,
  rmv_pt=find(dbt>axs(4) | dbt<axs(3) | pht>axs(2) | pht<axs(1));
  pht(rmv_pt)=pht(rmv_pt)+NaN;
  dbt(rmv_pt)=dbt(rmv_pt)+NaN;
 end

 set(v,'xdata',pht,'ydata',dbt);
 set(v,'vis','on');

 if length(wbs),
  for j=1:length(wbs),
   q=find(wt>=wbs(j) & ~isnan(wt));  q2=find(wt<=wbs(j) & ~isnan(wt));
   if ~length(q) | ~length(q2), loc(j)=NaN; else loc(j)=q(1); end
  end
  for j=1:length(wbs),
   if ~isnan(loc(j)),
    set(vo(j),'xdata',pht(loc(j)),'ydata',dbt(loc(j)));
    set(vo(j),'vis','on');
   end
  end
 end
end
