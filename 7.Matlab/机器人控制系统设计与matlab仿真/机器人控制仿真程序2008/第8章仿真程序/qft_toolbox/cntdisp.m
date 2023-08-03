function wht=cntdisp(f,cont,flag,name)
% CNTDISP Controller display. (Utility Function)
%         CNTDISP displays the present controller.  It also sets up the
%         window for Edit, Iterate, Delete, Conversion and Reduction.

% Author: Craig Borghesani
% 10/10/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
T=get(bthan(13),'userdata');
hint_bar = get(bthan(36),'userdata');

flag3 = infmat(9,1);
delay = infmat(10,1);
proc_num = int2str(infmat(25,2));
f2 = findobj('tag',['qft3',proc_num]);
fig_color=[0.5,0.5,0.5];

if ~length(f2),
 f2 = colordef('new','none');
 set(f2,'numbertitle','off','position',[320,200,300,10],...
        'menubar','none','color',fig_color,...
        'vis','off','userdata',f,'tag',['qft3',proc_num]);
 set(gca,'vis','off');
 infmat(15,1)=f2;
 infmat([17,21],1) = [0;0];
 set(bthan([23,24]),'userdata',[]);
end

wpos=get(f2,'pos');
dely=15;

proc_str=[];
if infmat(25,2)>1, proc_str=[' (',int2str(infmat(25,2)),')']; end

% turn all present children off
if any(flag==[2,9])
 t=get(bthan(24),'userdata');
 if ~length(t),
  for ct=1:50,
   t(ct)=uicontrol(f2,'vis','off','pos',[0,0,0.1,0.1],...
                      'horizontalalignment','left');
  end
  set(bthan(24),'userdata',t);
 end
 t2=get(bthan(23),'userdata');
 if length(t2),
  set(t2,'vis','off','userdata',[]);
 end
else
 t=get(bthan(23),'userdata');
 if ~length(t),
  for ct=1:50,
   t(ct)=uicontrol(f2,'vis','off','pos',[0,0,0.1,0.1],...
                      'horizontalalignment','left');
  end
  set(bthan(23),'userdata',t);
 end
 t2=get(bthan(24),'userdata');
 if length(t2),
  set(t2,'vis','off','userdata',[]);
 end
end
if flag~=9,
 set(t,'vis','off','max',0,'value',0,'pos',[0,0,0.1,0.1]);
end
set(t,'horizontalalignment','left');
if infmat(17,1),
 set(infmat([17,20],1:3),'vis','off');
end

lft=10;
wb=700;
bt=-dely+6;
q=1;

% if called by VUW or View prepare the window size so that there is room
% for two buttons at the bottom
if flag~=0,
 bt=-dely+40;
end

% list of all element code numbers
% notch: 6
% lead/lag: 5
% second-order zero: 4
% second-order pole: 3
% real zero: 2
% real pole: 1
% continuous integrator: 0.7
% discrete delay/predictor: 0.5
% discrete integrator: 0.6
% gain: 0

str='string';
sty='style';
pos='pos';
callbk='';

if flag==1, % Conversion
 elem=[2 1];
 style='check';
 wht=45;
 nmstr=['Conversion',proc_str];
 set(hint_bar,'string','Select pole/zero pairs for conversion to lead/lag elements.');

elseif any(flag==[2,9]), % Reduction
 elem=[6 5 4 3 2 1 0.7 0.5 0.6];
 style='check';
 wht=45;
 nmstr=['Reduction',proc_str];
 set(hint_bar,'string','Deselect/Select a set of elements for model order reduction');

elseif any(flag==[4,6]), % Edit/Iterate
 elem=[6 5 4 3 2 1 0];
 style='radio';
 wb=280;
 wht=55;
 dely=19;
 lft=25;
 val=0;
 if flag==4,
  nmstr=['Edit',proc_str];
  set(hint_bar,'string','Select an element for editting by pressing the associated button.');
 else
  nmstr=['Iterate',proc_str];
  set(hint_bar,'string','Select an element to be iterated by pressing the associated button.');
 end

elseif flag==7, % Delete
 elem=[6 5 4 3 2 1 0.7 0.5 0.6];
 style='check';
 dely=19;
 wht=45;
 nmstr=['Delete',proc_str];
 set(hint_bar,'string','Select/Deselect elements to be deleted.');

else % Display elements while in ADD
 elem=[6 5 4 3 2 1 0.7 0.5 0.6 0];
 style='text';
 if nargin==3,
  nmstr = ['Elements',proc_str];
 else
  nmstr = [name,proc_str];
 end
 if flag, wht=45;
 else wht=10; end
end
wbt=wb;
drawnow;

if strcmp(nmstr,['Plant',proc_str]),
 wht=wht+dely;
 bt=bt+dely;
 if ~length(T),
  set(t(q),'style','text','enable','on',...
           'string',['Delay: ',num2str(delay),' sec'],...
           'backgroundcolor',fig_color,...
           'pos',[lft,bt,wb,dely]);
 else
  set(t(q),'style','text','enable','on',...
           'string',['Sampling Time: ',num2str(T),' sec'],...
           'backgroundcolor',fig_color,...
           'pos',[lft,bt,wb,dely]);
 end
 q=q+1;
end

for k = elem,
 wb=wbt;
 l=find(k==cont(:,4));
 if length(l),
  [sortvec,indexvec]=sort(cont(l,(1+any(k==[3:5])+2*(k==6))));
  l = l(indexvec); l = fliplr(l(:)');
  for h=1:length(l),
   if flag==6,
    callbk=['qitrelmt(',int2str(cont(l(h),4)),',',int2str(l(h)),')'];
   elseif flag==4,
    callbk=['qedtelmt(',int2str(cont(l(h),4)),',',int2str(l(h)),')'];
   elseif flag==7,
    callbk='qdelelmt(1)';
   end
   st=[];
   v1n=cont(l(h),1); v1=num2str(v1n,4);
   v2n=cont(l(h),2); v2=num2str(v2n,4);
   v3n=cont(l(h),3); v3=num2str(v3n,4);
   val=l(h);
   if k==0,
    wht=wht+dely;
    st=['Gain: [',v1,']'];
   elseif k==0.7,
    val=0;
    if cont(2,1)>0,
     wb=90;
     st='Integrator: ';
     if all(flag~=[2,7]),
      wht=wht+dely;
      wb=wbt;
      st=[st,'[',v1,']'];
     end
    elseif cont(2,1)<0,
     wb=105;
     st='Differentiator: ';
     if all(flag~=[2,7]),
      wht=wht+dely;
      wb=wbt;
      st=[st,'[',int2str(abs(v1n)),']'];
     end
    end
   elseif k==0.6,
    val=0;
    if cont(3,1)>0,
     wb=65;
     st='Delay: ';
     if all(flag~=[2,7]),
      wht=wht+dely;
      wb=wbt;
      st=[st,'[',int2str(abs(v1n)),']'];
     end
    elseif cont(3,1)<0,
     wb=95;
     st='Predictor: ';
     if all(flag~=[2,7]),
      wht=wht+dely;
      wb=wbt;
      st=[st,'[',int2str(abs(v1n)),']'];
     end
    end
   elseif k==0.5,
    val=0;
    if any(cont(2,1:2)~=0),
     wb=95;
     st='Integ/Diff: ';
     if all(flag~=[2,7]),
      wht=wht+dely;
      wb=wbt;
      st=[st,'[',int2str(cont(2,1)),'/',int2str(cont(2,2)),']'];
     end
    end
   elseif k==1,
    if v1n<0, val=0; end
    wht=wht+dely;
    st=['Real Pole: [',v1,']'];
    if length(T) & all(flag~=[4,6]),
     v1z=real(exp(-v1n*T));
     v1nz=num2str(v1z,8);
     st=[st,' [re=',v1nz,']'];
    end
   elseif k==2,
    wht=wht+dely;
    st=['Real Zero: [',v1,'] '];
    if length(T) & all(flag~=[4,6]),
     v1z=real(exp(-v1n*T));
     v1nz=num2str(v1z,8);
     st=[st,' [re=',v1nz,']'];
    end
   elseif k==3,
    wht=wht+dely;
    rt=roots([1,2*v1n*v2n,v2n^2]);
    if length(T),
     rt=exp(rt*T);
    end
    if length(T) & any(abs(rt)>1), val=0;
    elseif ~length(T) & any(real(rt)>=0), val=0;
    end
    st=['Complex Pole: [',v1,', ',v2,']'];
    if all(flag~=[4,6]),
     re=num2str(-real(rt(1)),4);
     im=num2str(imag(rt(1)),4);
     st=[st,' [re=',re,', im=',im,']'];
    end
   elseif k==4,
    wht=wht+dely;
    rt=roots([1,2*v1n*v2n,v2n^2]);
    if length(T),
     rt=exp(rt*T);
    end
    if length(T) & any(abs(rt)>1), val=0;
    elseif ~length(T) & any(real(rt)>=0), val=0;
    end
    st=['Complex Zero: [',v1,', ',v2,']'];
    if all(flag~=[4,6]),
     re=num2str(-real(rt(1)),4);
     im=num2str(imag(rt(1)),4);
     st=[st,' [re=',re,', im=',im,']'];
    end
   elseif k==5,
    wht=wht+dely;
    [jk,z,p]=ldlgcplx(v1n,v2n,[],T);
    st=['Lead/Lag: [',v1,', ',v2,']'];
    if all(flag~=[4,6]),
     st=[st,' [z=',z,', p=',p,']'];
    end
   elseif k==6,
    wht=wht+dely;
    st=['Notch: [',v1,', ',v2,', ',v3,']'];
    if all(flag~=[4,6]),
     rt1=roots([1,2*v1n*v3n,v3n^2]);
     if length(T),
      rt1=exp(rt1*T);
     end
     rt2=roots([1,2*v2n*v3n,v3n^2]);
     if length(T),
      rt2=exp(rt2*T);
     end
     re1=num2str(-real(rt1(1)),4);
     im1=num2str(imag(rt1(1)),4);
     re2=num2str(-real(rt2(1)),4);
     im2=num2str(imag(rt2(1)),4);
     st=[st,' [re1=',re1,', im1=',im1,', re2=',re2,', im2=',im2,']'];
    end
   end

   if length(st),
    bt=bt+dely;
    if flag==7, val=1; maxval = 1;
    elseif any(flag==[4,6]), val=0; maxval=1;
    else maxval = l(h); end
    if flag~=9,
     set(t(q),'style',style,'enable','on',...
              'string',st,...
              'backgroundcolor',fig_color,...
              'pos',[lft,bt,wb,dely],...
              'max',maxval,'value',val,...
              'callback',callbk,...
              'userdata',cont(l(h),:));
    end
    q=q+1;
    if any(flag==[2,7]) & k==0.7,
     if cont(2,1)>0,
      wht=wht+dely;
      set(t(q),sty,'edit',pos,[wb+15,bt,20,dely],str,int2str(cont(2,1)),...
                   'background',[1,1,1]);
      set(t(q-1),'userdata',[cont(l(h),:),t(q)]);
      q=q+1;
     elseif cont(2,1)<0,
      wht=wht+dely;
      set(t(q),sty,'edit',pos,[wb+15,bt,20,dely],str,int2str(abs(cont(2,1))),...
                   'background',[1,1,1]);
      set(t(q-1),'userdata',[cont(l(h),:),t(q)]);
      q=q+1;
     end
    elseif any(flag==[2,7]) & k==0.6,
     if cont(3,1)>0,
      wht=wht+dely;
      set(t(q),sty,'edit',pos,[wb+15,bt,20,dely],str,int2str(cont(3,1)),...
                   'background',[1,1,1]);
      set(t(q-1),'userdata',[cont(l(h),:),t(q)]);
      q=q+1;
     elseif cont(3,1)<0,
      wht=wht+dely;
      set(t(q),sty,'edit',pos,[wb+15,bt,20,dely],str,int2str(abs(cont(3,1))),...
                   'background',[1,1,1]);
      set(t(q-1),'userdata',[cont(l(h),:),t(q)]);
      q=q+1;
     end
    elseif any(flag==[2,7]) & k==0.5,
     if cont(2,1)~=0 | cont(2,2)~=0,
      wht=wht+dely;
      set(t(q),sty,'edit',pos,[wb+15,bt,20,dely],str,int2str(cont(2,1)),...
                     'background',[1,1,1]);
      q=q+1;
      set(t(q),sty,'text',pos,[wb+35,bt,10,dely],str,'/','background',fig_color,...
                'horizontalalignment','center');
      q=q+1;
      set(t(q),sty,'edit',pos,[wb+45,bt,20,dely],str,int2str(cont(2,2)),...
                     'background',[1,1,1]);
      set(t(q-3),'userdata',[cont(l(h),:),t(q-2),t(q)]);
      q=q+1;
     end
    end
   end
  end
 end
end

if infmat(21,1)==0,
 infmat(8,2) = uicontrol(f2,'style','frame','pos',[20,3,260,26],...
                         'backgroundcolor',[0,0.5020,0],'vis','off');
 infmat(21,1)=uicontrol(f2,'style','push','pos',[23,6,60,20],'vis','off');
 infmat(21,2)=uicontrol(f2,'style','push','pos',[86,6,60,20],'vis','off');
 infmat(21,3)=uicontrol(f2,'style','push','pos',[154,6,60,20],'vis','off');
 infmat(21,4)=uicontrol(f2,'style','push','pos',[217,6,60,20],'vis','off');
 set(bthan(16),'userdata',infmat);
else
 set(infmat(21,1:4),'vis','off');
 set(infmat(8,2),'vis','off');
end

if any(flag==[1,2,9]), % Conversion/Reduction
 set(infmat(8,2),'vis','on');
 callbk2='set(gcf,''vis'',''off'')';
 if flag==1,
  callbk='cntcnvt(1)';
  set(infmat(21,3),'vis','on','enable','off','string','UnDo',...
                   'callback','cntcnvt(4)');
  set(infmat(21,4),'vis','on','enable','off','string','Done',...
                   'callback','cntcnvt(3)');
 elseif any(flag==[2,9]),
  callbk='qmodlred(1)';
  callbk2='qmodlred(7)';
 end
 set(infmat(21,1),'vis','on','enable','on','string','Apply',...
                  'callback',callbk);
 set(infmat(21,2),'vis','on','string','Cancel','callback',callbk2);

elseif flag==3, % Conversion
 set(infmat(8,2),'vis','on');
 set(infmat(21,1),'vis','on','callback','cntcnvt(2)');
 set(infmat(21,3:4),'vis','on','enable','on');
 set(infmat(21,2),'vis','on');

elseif flag==5,
 set(infmat(8,2),'vis','on');
 set(infmat(21,1),'vis','on','enable','on','string','Close',...
                  'callback','set(gcf,''vis'',''off'');');

elseif any(flag==[4,6,7]),
 set(infmat(8,2),'vis','on');
 if flag==4, % Edit
  for c=1:(q-1),
   set(t(c),'userdata',t([1:(c-1),(c+1):(q-1)]));
  end
  set(infmat(21,1),'vis','on','enable','off','string','Apply');
  set(infmat(21,2),'vis','on','enable','on','string','Cancel',...
                   'callback','qedtelmt(8,1)');
  set(infmat(21,3),'vis','on','enable','off','string','UnDo',...
                   'callback','qundoit(2)');
  set(infmat(21,4),'vis','on','enable','off','string','Done');
 elseif flag==6, % Iterate
  for c=1:(q-1),
   set(t(c),'userdata',t([1:(c-1),(c+1):(q-1)]));
  end
  set(infmat(21,1),'vis','on','enable','off','string','Done',...
                   'callback','qitrelmt(9,1)');
  set(infmat(21,2),'vis','on','enable','on','string','Cancel',...
                   'callback','qitrelmt(8,1)');
  set(infmat(21,3),'vis','on','enable','off','string','UnDo',...
                   'callback','qundoit(3)');
 elseif flag==7, % Delete
  set(infmat(21,1),'vis','on','enable','off','string','Done',...
                   'callback','qdelelmt(2)');
  set(infmat(21,2),'vis','on','string','Cancel',...
                   'callback','qdelelmt(4)');
 end
end
set(t(1:(q-1)),'vis','on');
set(f2,'pos',[wpos(1:3),wht],'name',nmstr);
if nargout==0 & flag~=0, figure(f2);
else set(f2,'vis','on'); end
