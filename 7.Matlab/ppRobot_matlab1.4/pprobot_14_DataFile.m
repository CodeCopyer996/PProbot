% Simscape(TM) Multibody(TM) version: 7.3

% This is a model data file derived from a Simscape Multibody Import XML file using the smimport function.
% The data in this file sets the block parameter values in an imported Simscape Multibody model.
% For more information on this file, see the smimport function help page in the Simscape Multibody documentation.
% You can modify numerical values, but avoid any other changes to this file.
% Do not add code to this file. Do not edit the physical units shown in comments.

%%%VariableName:smiData


%============= RigidTransform =============%

%Initialize the RigidTransform structure array by filling in null values.
smiData.RigidTransform(9).translation = [0.0 0.0 0.0];
smiData.RigidTransform(9).angle = 0.0;
smiData.RigidTransform(9).axis = [0.0 0.0 0.0];
smiData.RigidTransform(9).ID = '';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(1).translation = [31.286796564403634 35.573105046621599 86.614425323734821];  % mm
smiData.RigidTransform(1).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(1).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(1).ID = 'B[joint3-1:-:leg1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(2).translation = [3.1263880373444408e-13 -9.9740881894879357e-13 -69.536796564403858];  % mm
smiData.RigidTransform(2).angle = 3.1415926535897891;  % rad
smiData.RigidTransform(2).axis = [-1 -7.3493486677817262e-31 3.5327080320385106e-16];
smiData.RigidTransform(2).ID = 'F[joint3-1:-:leg1-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(3).translation = [-4.2628156650914412e-13 -4.5582683496248643e-13 58.999999999999986];  % mm
smiData.RigidTransform(3).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(3).axis = [1 0 0];
smiData.RigidTransform(3).ID = 'B[base3-1:-:joint3-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(4).translation = [-4.2628156650914412e-13 -4.5582683496248643e-13 -13.999999999999986];  % mm
smiData.RigidTransform(4).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(4).axis = [1 0 0];
smiData.RigidTransform(4).ID = 'F[base3-1:-:joint3-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(5).translation = [220.00000000000014 0 55.750000000000043];  % mm
smiData.RigidTransform(5).angle = 1.1102230246251495e-16;  % rad
smiData.RigidTransform(5).axis = [1 0 0];
smiData.RigidTransform(5).ID = 'B[leg1-1:-:leg2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(6).translation = [-2.2737367544323206e-13 -1.2789769243681803e-13 50.000000000000007];  % mm
smiData.RigidTransform(6).angle = 3.6558639266546037e-16;  % rad
smiData.RigidTransform(6).axis = [-0.9912138382595056 -0.13226914546808952 2.3965468937452189e-17];
smiData.RigidTransform(6).ID = 'F[leg1-1:-:leg2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(7).translation = [289.50000000000023 -45.000000000000931 2.5000000000000231];  % mm
smiData.RigidTransform(7).angle = 0;  % rad
smiData.RigidTransform(7).axis = [0 0 0];
smiData.RigidTransform(7).ID = 'B[leg2-1:-:ball3-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(8).translation = [-3.5527136788005009e-14 1.8758328224066645e-12 -3.979039320256561e-13];  % mm
smiData.RigidTransform(8).angle = 0;  % rad
smiData.RigidTransform(8).axis = [0 0 0];
smiData.RigidTransform(8).ID = 'F[leg2-1:-:ball3-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(9).translation = [0 0 0];  % mm
smiData.RigidTransform(9).angle = 0;  % rad
smiData.RigidTransform(9).axis = [0 0 0];
smiData.RigidTransform(9).ID = 'RootGround[base3-1]';


%============= Solid =============%
%Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)

%Initialize the Solid structure array by filling in null values.
smiData.Solid(5).mass = 0.0;
smiData.Solid(5).CoM = [0.0 0.0 0.0];
smiData.Solid(5).MoI = [0.0 0.0 0.0];
smiData.Solid(5).PoI = [0.0 0.0 0.0];
smiData.Solid(5).color = [0.0 0.0 0.0];
smiData.Solid(5).opacity = 0.0;
smiData.Solid(5).ID = '';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(1).mass = 1.7935203353930644;  % kg
smiData.Solid(1).CoM = [67.467318534006097 -56.922893116336859 -0.1373129493535033];  % mm
smiData.Solid(1).MoI = [2530.3373786493744 15396.49569576403 16347.617023414412];  % kg*mm^2
smiData.Solid(1).PoI = [150.74453202349792 -36.843648974679361 -1627.0215164025046];  % kg*mm^2
smiData.Solid(1).color = [1 1 1];
smiData.Solid(1).opacity = 1;
smiData.Solid(1).ID = 'leg2*:*默认';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(2).mass = 1.1180811704379827;  % kg
smiData.Solid(2).CoM = [34.35628829358626 -17.498016499712101 43.417454348945718];  % mm
smiData.Solid(2).MoI = [4291.757987372579 4474.8263206249858 6025.8425899220701];  % kg*mm^2
smiData.Solid(2).PoI = [-1286.3238444231597 -278.46828514744152 492.13692608419882];  % kg*mm^2
smiData.Solid(2).color = [1 1 1];
smiData.Solid(2).opacity = 1;
smiData.Solid(2).ID = 'joint3*:*默认';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(3).mass = 1.1211403743047721;  % kg
smiData.Solid(3).CoM = [102.00542180427517 -0.049200959942502127 -14.818198254438789];  % mm
smiData.Solid(3).MoI = [1912.9174842663754 5680.3144464198886 4076.7510907660285];  % kg*mm^2
smiData.Solid(3).PoI = [-0.41281232249052863 49.399505582945835 -3.1723303861096586];  % kg*mm^2
smiData.Solid(3).color = [1 1 1];
smiData.Solid(3).opacity = 1;
smiData.Solid(3).ID = 'leg1*:*默认';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(4).mass = 0.74132949599121334;  % kg
smiData.Solid(4).CoM = [0.3835251463985524 68.149125448408768 25.846704142070962];  % mm
smiData.Solid(4).MoI = [3033.6517702515398 324.6593790927592 2903.1966455204015];  % kg*mm^2
smiData.Solid(4).PoI = [-102.46849372155798 -2.3237712233180141 -10.696375492922916];  % kg*mm^2
smiData.Solid(4).color = [1 1 1];
smiData.Solid(4).opacity = 1;
smiData.Solid(4).ID = 'base3*:*默认';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(5).mass = 0.00052359877559829892;  % kg
smiData.Solid(5).CoM = [0 0 0];  % mm
smiData.Solid(5).MoI = [0.005235987755982989 0.0052359877559829899 0.005235987755982989];  % kg*mm^2
smiData.Solid(5).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(5).color = [1 1 1];
smiData.Solid(5).opacity = 1;
smiData.Solid(5).ID = 'ball3*:*默认';


%============= Joint =============%
%X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
%X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
%Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
%Position Target (Pos)

%Initialize the RevoluteJoint structure array by filling in null values.
smiData.RevoluteJoint(3).Rz.Pos = 0.0;
smiData.RevoluteJoint(3).ID = '';

smiData.RevoluteJoint(1).Rz.Pos = 90.000000000000099;  % deg
smiData.RevoluteJoint(1).ID = '[joint3-1:-:leg1-1]';

smiData.RevoluteJoint(2).Rz.Pos = 0;  % deg
smiData.RevoluteJoint(2).ID = '[base3-1:-:joint3-1]';

smiData.RevoluteJoint(3).Rz.Pos = 90.000000000000242;  % deg
smiData.RevoluteJoint(3).ID = '[leg1-1:-:leg2-1]';


%Initialize the SphericalJoint structure array by filling in null values.
smiData.SphericalJoint(1).S.Pos.Angle = 0.0;
smiData.SphericalJoint(1).S.Pos.Axis = [0.0 0.0 0.0];
smiData.SphericalJoint(1).ID = '';

smiData.SphericalJoint(1).S.Pos.Angle = 119.99999999999997;  % deg
smiData.SphericalJoint(1).S.Pos.Axis = [0.57735026918962795 0.57735026918962407 -0.5773502691896254];
smiData.SphericalJoint(1).ID = '[leg2-1:-:ball3-1]';

