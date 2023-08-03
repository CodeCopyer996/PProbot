function bndonoff
% BNDONOFF Bound buttons. (Utility Function)
%          BNDONOFF 'turns on' and 'turns off' the bound which the user
%          has selected using the push buttons on the  side of the IDE
%          environment in LPSHAPE and DLPSHAPE.

% Author: Craig Borghesani
% 10/10/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

f=gcf;
obj=get(f,'currentobject');

% obtain the handles to all the lines that make up the selected bound
bnddata=get(obj,'userdata');

str=get(obj,'string');
if strcmp('On',str) | strcmp('Off',str),
 if strcmp(str,'On'),
  set(bnddata(bnddata~=0),'vis','on');
  set(obj,'string','Off');
 else
  set(bnddata(bnddata~=0),'vis','off');
  set(obj,'string','On');
 end
else
 if strcmp(get(bnddata(1),'vis'),'on'),
  set(bnddata(bnddata~=0),'vis','off');
 else
  set(bnddata(bnddata~=0),'vis','on');
 end
end
