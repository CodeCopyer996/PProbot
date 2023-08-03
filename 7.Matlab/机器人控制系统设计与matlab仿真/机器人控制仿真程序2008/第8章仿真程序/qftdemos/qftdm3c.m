function qftdm3c
% Third stage of QFTDM3
%=================================

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

global win1_loc win2_loc win3_loc win4_loc ...
       info_win info_str info_btn nompt ...
       nump denp P w W1 bdb1 W2 bdb2 ...
       ubdb ...
       wl nc0 dc0

% close all windows from last stage and clear strings in information window
close(findobj('tag','qft'));
set(info_str,'string','');

% DESIGN
%=================================
set(info_str(1),'string','Initiating LPSHAPE with pre-designed controller');
set(info_str(2),'string','lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);');

% define a frequency array for loop shaping
wl = logspace(-2,8,300);  % define a frequency array for loop shaping

% obtain nominal plant from plant set
nL0=nump;
dL0=denp;

% no delay
del0=0;

% define initial controller
nc0=[ 5.032245193701399e+015
    1.047651224010599e+021
    2.783298073926963e+025
    2.091612032833357e+029
    3.180392975934304e+032
    8.265557006790552e+034
    2.627506261665202e+036
    4.929810064633756e+036
    2.260724023982798e+036]';
dc0=[1.000000000000000e+000
    1.123537042440132e+006
    2.734200460173087e+012
    7.574140703600440e+017
    4.919207207185055e+022
    7.266655789062400e+026
    2.669203151502317e+030
    1.910241138970628e+033
    1.932735079737017e+035
                         0]';
lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);

% setup for call to next stage
qftexit('qftdm3d',info_btn);
