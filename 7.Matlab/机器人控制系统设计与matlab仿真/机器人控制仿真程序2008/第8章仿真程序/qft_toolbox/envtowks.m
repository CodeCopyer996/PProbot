function [val1,val2,val3,val4,val5,val6,val7,val8,val9] = envtowks(flag,flag2)
% ENVTOWKS Environment to workspace. (Utility Function)
%          ENVTOWKS provides a gateway from the environment to the workspace
%          for the user during an IDE session.

% Author: Craig Borghesani
% 7/9/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

if flag~=0,
 f2 = gcf;
 f = get(f2,'userdata');
 bthan=get(f,'userdata');
 infmat=get(bthan(16),'userdata');
 hint_bar = get(bthan(36),'userdata');
end


if flag==0, % Setup

 f = gcf;
 bthan = get(f,'userdata');
 infmat = get(bthan(16),'userdata');
 del=25;

 hint_bar = get(bthan(36),'userdata');
 proc_num = int2str(infmat(25,2));
 win_tag = findobj('tag',['qft6',proc_num]);
 fig_color = [0.5,0.5,0.5];
 if ~length(win_tag),
  infmat(31,1) = colordef('new','none');
  set(infmat(31,1),'numbertitle','off','menubar','none','name','Out to Workspace',...
                'pos',[30,50,415,170],'color',fig_color,'resize','off',...
                'userdata',f,'tag',['qft6',proc_num]);

  f2 = infmat(31,1);
% Numerator/Denominator
  uicontrol(f2,'style','text','string','Numerator/Denominator:',...
            'pos',[10,165-del,160,17],'horizontalalignment','left',...
            'backgroundcolor',[0,0.5020,0]);
  uicontrol(f2,'style','text','string','Num:',...
            'pos',[10,140-del,30,20],'horizontalalignment','right',...
            'back',fig_color);
  edt(1) = uicontrol(f2,'style','edit','pos',[45,140-del,60,20],'backgroundcolor','w',...
                     'callback','envtowks(1,0)');
  uicontrol(f2,'style','text','string','Den:',...
            'pos',[110,140-del,30,20],'horizontalalignment','right',...
            'back',fig_color);
  edt(2) = uicontrol(f2,'style','edit','pos',[145,140-del,60,20],'backgroundcolor','w',...
                     'callback','envtowks(1,0)');

% Zero/Pole/Gain
  uicontrol(f2,'style','text','string','Zero/Pole/Gain:',...
            'pos',[10,115-del,160,17],'horizontalalignment','left',...
            'backgroundcolor',[0,0.5020,0]);
  uicontrol(f2,'style','text','string','Z:',...
            'pos',[10,90-del,30,20],'horizontalalignment','right',...
            'back',fig_color);
  edt(3) = uicontrol(f2,'style','edit','pos',[45,90-del,60,20],'backgroundcolor','w',...
                     'callback','envtowks(1,0)');
  uicontrol(f2,'style','text','string','P:',...
            'pos',[110,90-del,30,20],'horizontalalignment','right',...
            'back',fig_color);
  edt(4) = uicontrol(f2,'style','edit','pos',[145,90-del,60,20],'backgroundcolor','w',...
                     'callback','envtowks(1,0)');
  uicontrol(f2,'style','text','string','K:',...
            'pos',[210,90-del,30,20],'horizontalalignment','right',...
            'back',fig_color);
  edt(5) = uicontrol(f2,'style','edit','pos',[245,90-del,60,20],'backgroundcolor','w',...
                     'callback','envtowks(1,0)');

% State Space
  uicontrol(f2,'style','text','string','State Space:',...
            'pos',[10,65-del,160,17],'horizontalalignment','left',...
            'backgroundcolor',[0,0.5020,0]);
  uicontrol(f2,'style','text','string','A:',...
            'pos',[10,40-del,30,20],'horizontalalignment','right',...
            'back',fig_color);
  edt(6) = uicontrol(f2,'style','edit','pos',[45,40-del,60,20],'backgroundcolor','w',...
                     'callback','envtowks(1,0)');
  uicontrol(f2,'style','text','string','B:',...
            'pos',[110,40-del,30,20],'horizontalalignment','right',...
            'back',fig_color);
  edt(7) = uicontrol(f2,'style','edit','pos',[145,40-del,60,20],'backgroundcolor','w',...
                     'callback','envtowks(1,0)');
  uicontrol(f2,'style','text','string','C:',...
            'pos',[210,40-del,30,20],'horizontalalignment','right',...
            'back',fig_color);
  edt(8) = uicontrol(f2,'style','edit','pos',[245,40-del,60,20],'backgroundcolor','w',...
                     'callback','envtowks(1,0)');
  uicontrol(f2,'style','text','string','D:',...
            'pos',[310,40-del,30,20],'horizontalalignment','right',...
            'back',fig_color);
  edt(9) = uicontrol(f2,'style','edit','pos',[345,40-del,60,20],'backgroundcolor','w',...
                     'callback','envtowks(1,0)');

  set(edt,'horiz','left');
  uicontrol(f2,'style','frame','pos',[346,118,66,49],'backgroundcolor',[0,0.5020,0]);
  psh(1) = uicontrol(f2,'style','push','pos',[349,144,60,20],'string','OK');
  uicontrol(f2,'style','push','pos',[349,121,60,20],'string','Cancel',...
            'callback','envtowks(3,0)');

  set(bthan(35),'userdata',[psh,edt]);
  set(bthan(16),'userdata',infmat);
  set(f2,'vis','on');
 else
  set(infmat(31,1),'vis','on');
 end

 set(hint_bar,'string','Enter variable names you wish to be passed to the workspace');
 drawnow;

elseif flag==1, % edit fields

 handles = get(bthan(35),'userdata');
 psh = handles(1);
 edt = handles(2:10);

% build output and input strings
 output_str = '[';
 input_str = '[';

 for k = 1:9,
  var_str = get(edt(k),'string');
  if length(var_str),
   output_str = [output_str,var_str,','];
   input_str = [input_str,int2str(k),','];
  end
 end

% remove extra comma and place ] at end of string
 output_str(length(output_str))=[];
 input_str(length(input_str))=[];
 output_str = [output_str,']'];
 input_str = [input_str,']'];

% setup callback to pass desired variables to workspace
 callback_str = [output_str,'=envtowks(2,',input_str,');'];
 set(psh,'callback',callback_str);

elseif flag==2, % OK

 T = get(bthan(13),'userdata');

 cont_r = get(bthan(3),'userdata');
 cont2 = get(bthan(31),'userdata');
 if length(cont2),
  cont_r(1,1) = cont_r(1,1)*cont2(1,1);
  if length(T),
   cont_r(3,1) = cont_r(3,1)+cont2(3,1);
   cont2(1:3,:) = [];
  else
   cont2(1:2,:) = [];
  end
  cont_r = [cont_r;cont2];
 end

 if any(flag2==1) | any(flag2==2),
  [var1,var2]=cntextr(cont_r,T);
 end

 if any(flag2==3) | any(flag2==4) | any(flag2==5),
  [var3,var4,var5]=cnt2zpk(cont_r,T);
 end

 if any(flag2==6) | any(flag2==7) | any(flag2==8) | any(flag2==9),
  [z,p,k]=cnt2zpk(cont_r,T);
  if ~length(T),
   [do_it,repeat,jk] = chkzp(z,p,T);
   if do_it,
    if repeat,
     [sysb,hsv]=qfwbal(z,p,k,[],'z');
    else
     [r,p,k]=qzp2rp(z,p,k);
     [sysb,hsv]=qfwbal(r,p,k,[],'r');
    end
    [sr,sc] = size(sysb);
    var6 = sysb(1:sr-2,1:sc-2);
    var7 = sysb(1:sr-2,sc-1);
    var8 = sysb(sr-1,1:sc-2);
    var9 = sysb(sr-1,sc-1);
   else
    [var6,var7,var8,var9]=zp2ss(z,p,k);
   end
  else
   [var6,var7,var8,var9]=zp2ss(z,p,k);
  end
 end

 ct=1;
 for k = flag2,
  eval(['val',int2str(ct),'=var',int2str(k),';']);
  ct=ct+1;
 end

 set(hint_bar,'string','Variables passed to workspace');

 set(infmat(31,1),'vis','off');

elseif flag==3, % Cancel

 set(infmat(31,1),'vis','off');
 handles = get(bthan(35),'userdata');
 edt = handles(2:9);
 set(edt,'string','');

end
