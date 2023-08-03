function [uP,vP,uG,vG,uH,vH,uF,vF,sgn,typ]=clnddef(uP,vP,uG,vG,uH,vH,uF,...
                                                   vF,sgn,typ);
% CLNDDEF Set defaults for CLND. (Utility Function)
%         CLNDDEF sets the defaults for whatever the user either passed in
%         as [] or did not specify at all for CLND.

% Author: Craig Borghesani
% 9/2/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

if ~length(uP), uP=1; end
if ~length(vP), vP=1; end
if ~length(uG), uG=1; end
if ~length(vG), vG=1; end
if ~length(uH), uH=1; end
if ~length(vH), vH=1; end
if ~length(uF), uF=1; end
if ~length(vF), vF=1; end
if ~length(sgn), sgn=-1; end
if ~length(typ), typ=1; end
