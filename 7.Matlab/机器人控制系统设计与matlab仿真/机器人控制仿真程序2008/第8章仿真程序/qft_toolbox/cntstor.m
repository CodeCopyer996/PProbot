function cntstor
% CNTSTOR Store controller matrix. (Utility Function)
%         CNTSTOR stores the present design within the IDE environment.
%         It is then retrieved using CNTRECL.

% Author: Craig Borghesani
% 9/2/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

f=gcf;
bthan=get(f,'userdata');
infmat=get(bthan(16),'userdata');
T = get(bthan(13),'userdata');

hint_bar = get(bthan(36),'userdata');
lomat=get(bthan(1),'userdata');
cont=get(bthan(3),'userdata');
cont2 = get(bthan(31),'userdata');
if length(cont2),
 cont(1,1) = cont(1,1)*cont2(1,1);
 if length(T),
  cont(3,1) = cont(3,1)+cont2(3,1);
  cont2(1:3,:) = [];
 else
  cont2(1:2,:) = [];
 end
 cont = [cont;cont2];
end

set(bthan(5),'userdata',cont);
set(bthan(7),'userdata',lomat(1,:));
set(bthan(9),'userdata',lomat(2:2+(infmat(9,1)==2),:));

set(hint_bar,'string','Current design stored within CAD');
