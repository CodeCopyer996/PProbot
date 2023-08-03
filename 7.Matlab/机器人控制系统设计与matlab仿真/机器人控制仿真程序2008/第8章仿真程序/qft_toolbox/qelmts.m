function qelmts(flag,flag2)
% QELMTS Compute and store individual terms. (Utility Function)
%        QELMTS computes the various frequency responses of the element
%        that is selected from within the Add or Edit window.

% Author: Craig Borghesani
% 9/5/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

f2=gcf;
f=get(f2,'userdata');
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
butn = get(f2,'currentobject');

flag3=infmat(9,1);
lomat=get(bthan(20),'userdata');
T=get(bthan(13),'userdata');
cont=get(bthan(19),'userdata');
selctn=get(bthan(30),'userdata');
butn_sel=0;

if flag2,
 butn_sel = get(infmat(21,1),'userdata');
 cur_str = get(butn_sel,'string');
 brac = find(cur_str=='[');
 new_str = cur_str(1:brac);
 set(infmat(21,[2,3]),'enable','on');
end
selctn=[[flag2,butn_sel,NaN,NaN,NaN];selctn];

% depending upon whether the mode is add or edit determines the location
% of the data that was entered
if flag2, % Edit
 loc=17; loc2=21;
else % Add
 loc=16; loc2=13;
end

% setting up for whether FSHAPE/DFSHAPE is being used
if any(flag3==[1 3]), % SHAPE/DSHAPE/BODPLOT/DBODPLOT
 q=1; s=0;
elseif flag3==2, % FSHAPE/DFSHAPE
 q=[1;1]; s=1;
end

go_for_it=0;

if flag==0, % gain
 val=str2num(get(infmat(loc,1),'string'));
 if length(val),
  lomat(2:2+s,:)=lomat(2:2+s,:).*(val/cont(1,1));
  selctn(1,3)=cont(flag2,1);
  cont(1,1)=val;
  v1=num2str(cont(flag2,1),4);
  set(butn_sel,'string',[new_str,v1,']']);
  go_for_it=1;
 else
  errordlg('Gain value needs to be a number','Message','on');
 end

elseif any(flag==[1 2]), % first order
 val=str2num(get(infmat(loc,1),'string'));
 str=['Pole';'Zero'];
 if ~flag2,
  if val~=0 & length(val),
   if imag(val)~=0,
    sign_imag = sign(imag(val));
    val = real(val) + sign_imag*pi/T*i;
   end
   rtnv=rlroot(val,lomat(1,:),[(flag==2)-(flag==1) T]);
   lomat(2:2+s,:)=lomat(2:2+s,:).*rtnv(q,:);
   cont=[cont;val,NaN,NaN,flag];
   go_for_it=1;
  elseif length(val),
   errordlg([str(flag,:),' cannot be = 0'],'Message','on');
  else
   errordlg('First Order value must be a number','Message','on');
  end
 else
  if val~=0 & length(val),
   if imag(val)~=0,
    sign_imag = sign(imag(val));
    val = real(val) + sign_imag*pi/T*i;
   end
   rtnv=rlroot(val,lomat(1,:),[(flag==2)-(flag==1) T]);
   rt=rlroot(cont(flag2,1),lomat(1,:),[(flag==2)-(flag==1) T]);
   lomat(2:2+s,:)=lomat(2:2+s,:).*(rtnv(q,:)./rt(q,:));
   selctn(1,3)=cont(flag2,1);
   cont(flag2,1)=val;
   v1=num2str(cont(flag2,1),4);
   set(butn_sel,'string',[new_str,v1,']']);
   go_for_it=1;
  elseif length(val),
   errordlg([str(flag,:),' cannot be = 0'],'Message','on');
  else
   errordlg('First Order value must be a number','Message','on');
  end
 end

elseif any(flag==[3 4]), % second order
 val=str2num(get(infmat(loc,2),'string'));
 val2=str2num(get(infmat(loc,1),'string'));
 zeta=val; wn=val2; delay=infmat(10,1);
 if length([val,val2]) == 2,
  if val2~=0,
   if ~flag2,
    nom=get(bthan(2),'userdata');
    cont=[cont;zeta,wn,NaN,flag];
    if length(nom) & abs(zeta)<0.7 & flag3~=2,
     wlt=qfrqenh(wn,zeta,lomat(1,:),T);
     if flag3==1,
      nlo=qcpqft(nom(1,:),nom(2,:),wlt,T);
      clo=qcntbode(cont,wlt,T).*exp(-i*wlt*delay);
      lo=nlo.*clo;
     else
      lo=qcntbode(cont,wlt,T).*exp(-i*wlt*delay);
     end
     lomat=[wlt;lo;ones(1,length(lo))];
    else
     rt=cproot(zeta,wn,lomat(1,:),[(flag==4)-(flag==3) T]);
     lomat(2:2+s,:)=lomat(2:2+s,:).*rt(q,:);
    end
    go_for_it=1;
   else
    rtnv=cproot(zeta,wn,lomat(1,:),[(flag==4)-(flag==3) T]);
    rt=cproot(cont(flag2,1),cont(flag2,2),lomat(1,:),[(flag==4)-(flag==3) T]);
    lomat(2:2+s,:)=lomat(2:2+s,:).*(rtnv(q,:)./rt(q,:));
    selctn(1,3:4)=cont(flag2,1:2);
    cont(flag2,1:2)=[zeta,wn];
    v1=num2str(cont(flag2,1),4);
    v2=num2str(cont(flag2,2),4);
    set(butn_sel,'string',[new_str,v1,', ',v2,']']);
    go_for_it=1;
   end
  else
   errordlg('wn cannot be = 0','Message','on');
  end
 else
  errordlg('Second Order values must be numbers','Message','on');
 end


% continuous integrators/differentiators or
% discrete predictors/delays
elseif any(flag==[0.6,0.7]),
 val=str2num(get(infmat(loc,1),'string'));
 if length(val),
  rt=cintegtr(val,lomat(1,:),T);
  lomat(2:2+s,:)=lomat(2:2+s,:).*rt(q,:);
  cont(2+(length(T)),1)=val+cont(2+(length(T)),1);
  go_for_it=1;
  selctn(1,1:2)=[2+length(T),val];
 else
  errordlg('Value must be an integer','Message','on');
 end

elseif flag==0.5, % discrete integrators
 val=str2num(get(infmat(loc,1),'string'));
 if length(val),
  if (cont(2,1+(val<0))+abs(val))<=3,
   ca=dintegtr(cont(2,1+(val<0))+abs(val),lomat(1,:),T,-sign(val));
   cb=dintegtr(cont(2,1+(val<0)),lomat(1,:),T,-sign(val));
   cp=ca./cb;
   lomat(2:2+s,:)=lomat(2:2+s,:).*cp(q,:);
   cont(2,1+(val<0))=cont(2,1+(val<0))+abs(val);
   if (cont(2,1)-cont(2,2))==0, cont(2,1:2)=[0 0]; end
   go_for_it=1;
   selctn(1,1:2)=[2,val];
  else
   errordlg('No more than 3 integrators/differentiators allowed',...
            'Message','on');
  end
 else
  errordlg('Value must be an integer','Message','on');
 end

elseif flag==5, % lead/lag
 val=str2num(get(infmat(loc,2),'string'));
 val2=str2num(get(infmat(loc,1),'string'));
 phs=val; freq=val2;
 if length([val,val2]) == 2,
  if freq~=0 & abs(phs)<88,
   if ~flag2,
    rtnv=ldlgcplx(phs,freq,lomat(1,:),T);
    lomat(2,:)=lomat(2,:).*rtnv;
    cont=[cont;phs,freq,NaN,5];
   else
    rtnv=ldlgcplx(phs,freq,lomat(1,:),T);
    rt=ldlgcplx(cont(flag2,1),cont(flag2,2),lomat(1,:),T);
    lomat(2,:)=lomat(2,:).*(rtnv./rt);
    selctn(1,3:4)=cont(flag2,1:2);
    cont(flag2,1:2)=[phs,freq];
    v1=num2str(cont(flag2,1),4);
    v2=num2str(cont(flag2,2),4);
    set(butn_sel,'string',[new_str,v1,', ',v2,']']);
   end
   go_for_it=1;
  else
   if freq==0 & length(freq),
    errordlg('w cannot be = 0','Message','on');
   elseif abs(phs)>=88 & length(phs),
    errordlg('Phase change must be < 88 degrees','Message','on');
   end
  end
 else
  errordlg('Phase and Frequency must be numbers','Message','on');
 end

elseif flag==6, % Notch
 val=str2num(get(infmat(loc,3),'string'));
 val2=str2num(get(infmat(loc,2),'string'));
 val3=str2num(get(infmat(loc,1),'string'));
 if length([val,val2,val3])==3,
  ztas=[val,val2]; freq=val3; delay=infmat(10,1);
  zta=ztas(1+(ztas(1)>ztas(2)));
  if freq~=0,
   if ~flag2,
    cont=[cont;ztas(1),ztas(2),freq,6];
    nom=get(bthan(2),'userdata');
    if length(nom) & flag3~=2,
     wlt=qfrqenh(freq,zta,lomat(1,:),T);
     if flag3==1,
      nlo=qcpqft(nom(1,:),nom(2,:),wlt,T);
      clo=qcntbode(cont,wlt,T).*exp(-i*wlt*delay);
      lo=nlo.*clo;
     else
      lo=qcntbode(cont,wlt,T).*exp(-i*wlt*delay);
     end
     lomat=[wlt;lo;ones(1,length(lo))];
    else
     rt=ntchcplx(ztas(1),ztas(2),freq,lomat(1,:),T);
     lomat(2:2+s,:)=lomat(2:2+s,:).*rt(q,:);
    end
   else
    rtnv=ntchcplx(ztas(1),ztas(2),freq,lomat(1,:),T);
    rt=ntchcplx(cont(flag2,1),cont(flag2,2),cont(flag2,3),lomat(1,:),T);
    lomat(2:2+s,:)=lomat(2:2+s,:).*(rtnv(q,:)./rt(q,:));
    selctn(1,3:5)=cont(flag2,1:3);
    cont(flag2,1:3)=[ztas(1),ztas(2),freq];
    v1=num2str(cont(flag2,1),4);
    v2=num2str(cont(flag2,2),4);
    v3=num2str(cont(flag2,3),4);
    set(butn_sel,'string',[new_str,v1,', ',v2,', ',v3,']']);
   end
   go_for_it=1;
  else
   errordlg('wn cannot be = 0','Message','on');
  end
 else
  errordlg('Notch values must be numbers','Message','on');
 end
elseif flag==7, % Done
 go_for_it = 1;
end

if go_for_it,
 if strcmp(get(butn,'string'),'Done'),
  set(bthan([19,20]),'userdata',[]);
  set(bthan(1),'userdata',lomat);
  set(bthan(3),'userdata',cont);

  set(bthan([1,8,29]),'enable','on');
  if length(get(bthan(30),'userdata')),
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
   set(bthan(30),'userdata',[]);
   set(infmat(8,1),'enable','on');
  else
   if flag3==1, qnicplt(f);
   elseif flag3==2, qmagplt(f);
   elseif flag3==3, mgphplot(f);
   end
  end
  qclswin(1);
 else
  set(bthan(19),'userdata',cont);
  set(bthan(20),'userdata',lomat);
  set(bthan(30),'userdata',selctn);
  if flag3==1, qnicplt(f);
  elseif flag3==2, qmagplt(f);
  elseif flag3==3, mgphplot(f);
  end
  set(infmat(loc2,4),'callback','qelmts(7,0)');
  if ~flag2,
   cntdisp(f,cont,0);
   set(infmat(13,3),'enable','on');
  end
 end
end
