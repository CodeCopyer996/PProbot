% QFTSTRT1 First stage in beginning demonstration.
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.7 $

% save the user's workspace into a mat-file called USERVALS
%save uservals
%clc
%clear

% grab the QFT Demo window and turn it off
%demo_win = gcf;

% only turn off the QFT demos window if ran from qftdemo
%if length(findstr(get(demo_win,'name'),'QFT')),
%   set(demo_win,'vis','off');
%end

% determine which demonstration has been selected
qft_demos = {'Main Example';
             'QFT Tracking';
             'Non-Parametric Uncertainty';
             'Classical Design for Fixed Plant';
             'ACC Benchmark';
             'Missile';
             'Cascaded: Inner-Outer';
             'Cascaded: Outer-Inner';
             'Uncertain Flexible Mechanism';
             'Inverted Pendulum';
             'Active Vibration Isolation';
             'Main Example (Discrete-time)';
             'QFT Tracking (Discrete-time)';
             'CD Mechanism (Sampled-data)';
             '2x2 MIMO'};

% obtain figure name for info window
fig_str = qft_demos{qft_val};
