function putqft(fname,Ts,a1,b1,c1,d1)
% PUTQFT Interactively set QFT element matrix to mat-file.
%        PUTQFT(Ts,NUM,DEN) creates a dialog box that interactively allows
%        for the naming of the desired mat-file.  Ts is the sampling time
%        and NUM and DEN represent the transfer function with descending
%        powers of s or z.  This mat-file can then be opened by any of the
%        shaping environments.
%
%        PUTQFT(Ts,Z,P,K) interactively places the Zero/Pole/Gain format
%        into a mat-file that can be opened by the shaping environments.
%
%        PUTQFT(Ts,A,B,C,D) interactively places the State-Space format into
%        a mat-file that can be opened by the shaping environments.
%
%        PUTQFT(FNAME,Ts,...) directly writes the passed format into the
%        file specified by the string variable FNAME (i.e. 'myfile.mat').
%
%        Note: Ts MUST be specified in all cases.
%              For continuous-time, Ts equals [].
%              For discrete-time, Ts > 0.
%
%        The shaping environments look for files with the following
%        extensions:
%              LPSHAPE  - *.shp
%              DLPSHAPE - *.dsh
%              PFSHAPE  - *.fsh
%              DPFSHAPE - *.dfs
%
%        See also GETQFT, LPSHAPE, DLPSHAPE, PFSHAPE, DPFSHAPE.

% Author: Craig Borghesani
% Date: 9/14/93
% Revised: 2/21/96 12:30 PM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

nargval = nargin;
filepath = [];

if ~isstr(fname),
 if nargval == 3,
  den = a1; num = Ts; Ts = fname;
 elseif nargval == 4,
  k = b1; p = a1; z = Ts; Ts = fname;
 elseif nargval == 5,
  D = c1; C = b1; B = a1; A = Ts; Ts = fname;
 end
 [filename, filepath] = uiputfile('*.*','Put Element Matrix');
 nargval = nargval + 1;
else
 filename = fname;
 if nargval == 4,
  num = a1; den = b1;
 elseif nargval == 5,
  z = a1; p = b1; k = c1;
 elseif nargval == 6,
  A = a1; B = b1; C = c1; D = d1;
 end
end

if isstr(filename),
 if nargval == 4,
  cont_r = cntpars(num,den,Ts);
 elseif nargval == 5,
  [num,den] = zp2tf(z,p,k);
  cont_r = cntpars(num,den,Ts);
 elseif nargval == 6,
  [num,den] = ss2tf(A,B,C,D);
  cont_r = cntpars(num,den,Ts);
 end

 T = Ts;

 eval(['save ''',filepath,filename,''' cont_r T -mat']);

else

 disp('Warning: File not created.');

end
