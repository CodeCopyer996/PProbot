function tbxStruct = demos
% DEMOS Return demo information to the Matlap Expo.
% Copyright (c) 1995-98 by The MathWorks, Inc.
% $Revision: 1.8 $ $Date: 1998/04/10 15:36:23 $

if nargout == 0, demo toolbox; return; end

tbxStruct.Name = 'QFT Control Design';
tbxStruct.Type = 'toolbox';
tbxStruct.Help = { ...
   ' The QFT Control Design Toolbox '
   ' is a collection of MATLAB functions for '
   ' designing robust feedback systems '
   ' using Quantitative Feedback Theory.  '
   ' '
   ' QFT is an engineering method devoted to '
   ' the practical design of feedback systems. '
   ' It uses frequecy domain concepts to satisfy '
   ' performance specifications and to handle '
   ' plant uncertainty.  '
   ' '
   ' The QFT Control Toolbox includes a convenient '
   ' GUI that facilitates loop shaping for the '
   ' formulation of simple, low-order controllers to '
   ' meet design requirements.'};
tbxStruct.DemoList = { ...
   'Main Example',                     'qftdm1';
   'QFT Tracking',                     'qftdm2';
   'Non-Parametric Uncertainty',       'qftdm3';
   'Classical Design for Fixed Plant', 'qftdm4';
   'ACC Benchmark',                    'qftdm5';
   'Missile',                          'qftdm6';
   'Cascaded: Inner-Outer',            'qftdm7';
   'Cascaded: Outer-Inner',            'qftdm8';
   'Uncertain Flexible Mechanism',     'qftdm9';
   'Inverted Pendulum',                'qftdm10';
   'Active Vibration Isolation',       'qftdm11';
   'Main Example - Discrete-time'      'qftdm12';
   'QFT Tracking - Discrete-time',     'qftdm13';
   'CD Mechanism - Sampled-data',      'qftdm14';
   '2x2 MIMO',                         'qftdm15'};
