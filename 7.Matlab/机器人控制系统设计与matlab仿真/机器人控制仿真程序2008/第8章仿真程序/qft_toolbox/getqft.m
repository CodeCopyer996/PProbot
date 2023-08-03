function [a,b,c,d,t]=getqft(fname)
% GETQFT Interactively retrieve QFT element matrix from mat-file.
%        [NUM,DEN]=GETQFT places the contents of the chosen file into the
%        numerator/denominator format.  Elements in NUM and DEN are in
%        descending powers of s.
%
%        [Z,P,K]=GETQFT places the contents of the chosen file into the
%        zero/pole/gain format.  Z contains the zeros, P contains the poles,
%        and K contains the D.C. gain.
%
%        [A,B,C,D]=GETQFT places the contents into a balanced form.
%
%        [...,Ts]=GETQFT returns the desired discrete-time format and the
%        sampling-time, Ts.
%
%        [...]=GETQFT(FNAME) reads directly from the filename specified
%        by FNAME.  FNAME must be in quotes i.e. 'filename.shp'
%
%        FNAME can also be one of the file extensions associated with
%        a shaping environment. i.e. '*.shp'
%
%        The shaping environments create files with the following
%        extensions:
%              LPSHAPE  - *.shp
%              DLPSHAPE - *.dsh
%              PFSHAPE  - *.fsh
%              DPFSHAPE - *.dfs
%
%        See also PUTQFT, LPSHAPE, DLPSHAPE, PFSHAPE, DPFSHAPE.

% Author: Craig Borghesani
% Date: 9/14/93
% Revised: 2/16/96 1:18 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

% V5 initialization
a = []; b = []; c = []; d = []; t = [];

if nargin==0,
 fname = '*.*';
 [filename,pathname]=uigetfile(fname,'Get Element Matrix');
 if isstr(filename),
   eval(['load ''',pathname,filename,''' -mat']);
 else
   return;
 end

elseif strcmp(fname,'*.shp') | strcmp(fname,'*.dsh') | ...
       strcmp(fname,'*.fsh') | strcmp(fname,'*.dfs'),
 [filename,pathname]=uigetfile(fname,'Get Element Matrix');
 if isstr(filename),
   eval(['load ''',pathname,filename,''' -mat']);
 else
   return;
 end

else
 eval(['load ''',fname,''' -mat']);

end

Ts = T;

des_form = '';

if nargout == 2,
 des_form = 'num';
 if length(Ts),
  disp('Retrieving discrete-time numerator/denominator');
 else
  disp('Retrieving continuous-time numerator/denominator');
 end
end

if nargout == 3 & length(Ts),
 des_form = 'num';
 disp('Retrieving discrete-time numerator/denominator');
elseif nargout == 3,
 des_form = 'zpk';
 disp('Retrieving continuous-time zero/pole/gain');
end

if nargout == 4 & length(Ts),
 des_form = 'zpk';
 disp('Retrieving discrete-time zero/pole/gain');
elseif nargout == 4,
 des_form = 'abcd';
 disp('Retrieving continuous-time state-space form');
end

if nargout == 5,
 des_form = 'abcd';
 disp('Retrieving discrete-time state-space form');
end

if strcmp(des_form,'num'),
 [a,b]=cntextr(cont_r,T);
 c = T;
elseif strcmp(des_form,'zpk'),
 [a,b,c]=cnt2zpk(cont_r,T);
 d = T;
elseif strcmp(des_form,'abcd'),
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
   a = sysb(1:sr-2,1:sc-2);
   b = sysb(1:sr-2,sc-1);
   c = sysb(sr-1,1:sc-2);
   d = sysb(sr-1,sc-1);
  else
   [a,b,c,d]=zp2ss(z,p,k);
  end
 else
  [a,b,c,d]=zp2ss(z,p,k);
 end
 t = T;
end
