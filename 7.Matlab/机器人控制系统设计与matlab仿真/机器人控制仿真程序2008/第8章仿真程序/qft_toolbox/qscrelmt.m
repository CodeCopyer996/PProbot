function qscrelmt(flag)
% QSCRELMT Setup mouse window function. (Utility Function)
%          QSCRELMT initializes the specific mouse button down functions
%          for the adding of elements from the screen: K, 1, 2, L/L, NTC

% Author: Craig Borghesani
% 9/6/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

qclswin(0);

f=gcf;
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
lomat=get(bthan(1),'userdata');
cont=get(bthan(3),'userdata');
qabtns = get(bthan(34),'userdata');
hint_bar = get(bthan(36),'userdata');

set(infmat(8,1),'enable','on');
set(bthan(27),'userdata',lomat);
set(bthan(28),'userdata',cont);

T=get(bthan(13),'userdata');

if (any(diff(lomat(2,:))) & infmat(9,1)==1) | any(infmat(9,1)==[2,3]),

 set(qabtns([1:(flag-1),(flag+1):6]),'enable','off');

 opr=['mogain(0,0)  ';
      'mofirst(0,0) ';
      'mosecond(0,0)';
      'moldlg(0,0)  ';
      'montch(0,0)  ';
      'mo2ovr2(0)   ';];

 set(f,'windowbuttondownfcn',opr(flag,:))
 set(hint_bar,'string','Select a point on the frequency response by pressing and holding down the mouse button');

else
 errordlg('No frequency response is defined','Message','on');
end
