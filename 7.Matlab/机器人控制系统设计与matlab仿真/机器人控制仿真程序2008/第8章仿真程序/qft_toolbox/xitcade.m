function xitcade(f,flag)
% XITCADE Close all windows associated with shaping environments. (Utility)
%         XITCADE closes all windows associated with LPSHAPE, DLPSHAPE,
%         PFSHAPE, and DPFSHAPE.  It also offers the user a chance to save
%         a design or cancel the close.

% Author: Craig Borghesani
% Date: 9/6/93
% Revised: 2/17/96 10:22 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.7 $

bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
proc_num = int2str(infmat(25,2));
proc_str = [];
if infmat(25,2)>1, proc_str = [' (',proc_num,')']; end

if flag > 0,
 cont_r = get(bthan(3),'userdata');
 T = get(bthan(13),'userdata');
 cade = infmat(9,1)*2-(length(T)==0);
end

if flag==0,

 grey = [0.5,0.5,0.5];
 qclswin(0);
 win_tag = findobj('tag',['qft7',proc_num]);
 if ~length(win_tag),
  scrn_size=get(0,'screensize');
  left = (scrn_size(3) - 250)/2;
  botm = (scrn_size(4) - 62)/2;
  infmat(32,1) = colordef('new','none');
  set(infmat(32,1),'pos',[left,botm,250,62],'numbertitle','off','menubar','none',...
                   'color',grey,'resize','off','name',['Exit IDE',proc_str],...
                   'userdata',f,'vis','off','tag',['qft7',proc_num]);
  f2 = infmat(32,1);
  uicontrol(f2,'style','text','string','Save Design?','pos',[75,36,100,20],...
            'horizontalalignment','center','back',grey);

  uicontrol(f2,'style','frame','pos',[29,3,192,26],'backgroundcolor',[0,0.5020,0]);
  uicontrol(f2,'style','push','string','Yes','pos',[32,6,60,20],...
            'callback','cntsave(3)');
  uicontrol(f2,'style','push','string','No','pos',[95,6,60,20],...
            'callback',['xitcade(',int2str(f),',1)']);
  uicontrol(f2,'style','push','string','Cancel','pos',[158,6,60,20],...
            'callback',['xitcade(',int2str(f),',2)']);

  set(bthan(16),'userdata',infmat);
  drawnow;
 end
 set(infmat(32,1),'vis','on');

elseif flag==2, % Cancel
 set(infmat(32,1),'vis','off');

%elseif flag==3, % Save controller into tempfile and exit

% if cade==1, fname='shape.shp';
% elseif cade==2, fname='dshape.dsh';
% elseif cade==3, fname='fshape.fsh';
% elseif cade==4, fname='dfshape.dfs';
% elseif cade==5, fname='bodplot.bod';
% elseif cade==6, fname='dbodplot.dbo';
% end

% eval(['save ',fname,' cont_r T;']);

end

if any(flag==[1,3]),

 set(f,'closerequestfcn','');
 close(findobj('tag',['qft1',proc_num]));
 close(findobj('tag',['qft2',proc_num]));
 close(findobj('tag',['qft3',proc_num]));
 close(findobj('tag',['qft4',proc_num]));
 close(findobj('tag',['qft5',proc_num]));
 close(findobj('tag',['qft6',proc_num]));
 close(findobj('tag',['qft7',proc_num]));
 close(findobj(0,'tag','Hyper-Help Figure'));
 delete(f);
 leftover = get(0,'chil');
 for k=1:length(leftover),
  if strcmp(get(leftover(k),'name'),'Message'),
   close(leftover(k));
  end
 end

end
