function [cp] = mp2cp(m,p)
% MP2CP Convert magnitude/phase matrix to complex matrix.
%       CP=MP2CP(M,P) takes the magnitude/phase matrix and returns
%       the complex data in CP.
%
%       Rows and columns in the matrix correspond to cases and
%       frequencies, respectively.

% Author: Craig Borghesani
% 9/3/93
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

cp = m.*exp(i*pi/180*p);
