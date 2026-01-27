clc
close all
clear
format longG
addpath(genpath('./'));


minute = 60;
hour = 60*minute;
day = 24*hour;
year = 365*day;
maxTime = day*30;
timeVector = linspace(0,maxTime, 1e5+1);
plotTimeVector = timeVector/day;
% initial conditions in COEs J2 real space
%ecc0 = 0.0002542;
% inc0 = deg2rad(28.4704);
% sma0 = (525+Consts.Req)/(1-ecc0);
% raan0 = deg2rad(47.8475);
% aop0 = deg2rad(146.8877);
% aota0 = 0;


ecc0 = 0.0002542;
inc0 = deg2rad(28.4704);
sma0 = (525+Consts.Req)/(1-ecc0);
raan0 = deg2rad(47.8475);
aop0 = deg2rad(146.8877);
aota0 = 0;
approximateOrbitalPeriod = 2*pi*sqrt(sma0^3/Consts.mu);
chosenBridgeFunctionHandle = @bridgeToDepritSpace;


initialLeaderPosition = Position("COE",{sma0,ecc0,inc0,raan0,aop0,aota0});
leader = Satellite(initialLeaderPosition);


followerIntialDeltaFromLeaderCOE = Position("COE",{0,0,0,0,0,pi/3});


follower =...
    Satellite(...
    leader.position.getPositionInKeplerianDepritSpace(chosenBridgeFunctionHandle)...
    .add (followerIntialDeltaFromLeaderCOE)...
    .getPositionInFullJ2World(chosenBridgeFunctionHandle));


satellites = [leader,follower];


% Define ODE solver
ode_def = ode;
ode_def.ODEFcn = multiSatFcn;
ode_def.InitialValue = initialConditions;
ode_def.Solver = "ode45";
ode_def.RelativeTolerance = Defaults.RelTolerance;
ode_def.AbsoluteTolerance = Defaults.AbsTolerance;

% Define event sequence
















