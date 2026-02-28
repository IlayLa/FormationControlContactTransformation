clc
close all
clear
format longG
addpath(genpath('./'));


minute = 60;
hour = 60*minute;
day = 24*hour;
timeVector = linspace(0, day, 100);
ecc0 = 0.0002542;
inc0 = deg2rad(28.4704);
sma0 = (525+Consts.Req)/(1-ecc0);
raan0 = deg2rad(47.8475);
aop0 = deg2rad(146.8877);
aota0 = 0;

initialLeaderPosition = Position("COE",{sma0,ecc0,inc0,raan0,aop0,aota0});
leader = Satellite(initialLeaderPosition);

satellites = leader;

initialConditions = satellitesVectorToODEInitialConditions(satellites);

mem = struct();

eventSequencePropagatorWithNoEvents = EventSequencePropagator(@(t,y,mem) vectorizedStateSpace(@(t,y) j2StateSpace(t,y, Consts.mu,Consts.J2,Consts.Req), t, y), {}, {}, mem); 
eventSequencePropagatorWithNoEvents.solverName = "ode45";
regularPropagator = propMultiSatelliteStateSpace(...
        satellites,...
        timeVector,...
        {},...
        StateSpaceEnum.J2);





sNoControl = eventSequencePropagatorWithNoEvents.solve(timeVector,initialConditions,"No Events");



assert(all(vecnorm(sNoControl.Solution' - regularPropagator.Solution',2,2)==0))















