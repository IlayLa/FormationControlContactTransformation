clc
close all
clear
format longG
addpath(genpath('./'));


minute = 60;
hour = 60*minute;
day = 24*hour;
year = 365*day;
maxTime = day*50;
timeVector = [0,maxTime];
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


followerIntialDeltaFromLeaderCOE = Position("COE",{0,0,0,0,0,deg2rad(100)}).setWorldType("DEPRIT_KEPLER");


follower =...
    Satellite(...
    leader.position.getPositionInKeplerianDepritSpace(chosenBridgeFunctionHandle)...
    .add (followerIntialDeltaFromLeaderCOE)...
    .getPositionInFullJ2World(chosenBridgeFunctionHandle));


satellites = [leader,follower];

initialConditions = satellitesVectorToODEInitialConditions(satellites);

numOfPulses = 1;
[eventFunctions, postActions, mem0] = hamiltonianMatchingSequenceDefinition(numOfPulses, chosenBridgeFunctionHandle);


% Create propagator - specify event directions
prop = EventSequencePropagator(@(t,y,mem) vectorizedStateSpace(@(t,y) j2StateSpace(t,y, Consts.mu,Consts.J2,Consts.Req), t, y), eventFunctions, postActions, mem0);
propNoControl = EventSequencePropagator(@(t,y,mem) vectorizedStateSpace(@(t,y) j2StateSpace(t,y, Consts.mu,Consts.J2,Consts.Req), t, y), {}, {}, mem0); 


S = prop.solve(timeVector,initialConditions, "Hamiltonian Matching Sequence");
sNoControl = propNoControl.solve(timeVector,initialConditions, "No Pulse Control");

[PolarNodalsRealSpaceSimResults,PolarNodalsDepritSimResults] = ...
        extractPositionsFromSolutions(S, 2, chosenBridgeFunctionHandle);

[PolarNodalsRealSpaceSimResultsNoControl,PolarNodalsDepritSimResultsNoControl] = ...
        extractPositionsFromSolutions(sNoControl, 2, chosenBridgeFunctionHandle);


dist = physicalDistanceFromPolarNodals(PolarNodalsRealSpaceSimResults{1},PolarNodalsRealSpaceSimResults{2});

figure
distNoControl = physicalDistanceFromPolarNodals(PolarNodalsRealSpaceSimResultsNoControl{1},PolarNodalsRealSpaceSimResultsNoControl{2});
plot(sNoControl.Time/day, distNoControl-distNoControl(1),"DisplayName","only initial conditions")
hold on
plot(S.Time/day, dist-dist(1), 'DisplayName',sprintf("initial conditions with pulse at hamiltonian equilibrium of leader (%d-pulses)",numOfPulses))
legend

title("Satellite Distance Drift From Initial Distance")
subtitle("Normalized Initial Distance To Zero")
xlabel("time [days]")
ylabel("Distance Drift [km]")

