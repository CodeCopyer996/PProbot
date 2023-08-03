function [m,p] = cp2mp(cp)
% CP2MP Convert complex number to magnitude/phase.
%       [M,P]=CP2MP(CP) takes the complex numbers matrix and returns
%       the magnitude matrix in M and phase matrix in P.  Magnitude is
%       arithmetic and phase data is radians
%
%       Rows and columns in a matrix correspond to cases and
%       frequencies, respectively

% Author: Craig Borghesani
% 9/3/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

m = abs(cp); p = qatan4(cp);
