clc
close all
clear
format longG
addpath(genpath('./'));


minute = 60;
hour = 60*minute;
day = 24*hour;
year = 365*day;
maxTime = day*2;
timeVector = linspace(0,maxTime, 1e5+1);
plotTimeVector = timeVector/day;
% initial conditions in COEs J2 real space
initialEccentricity = 0.0002542;
initialInclination = deg2rad(28.4704);
initialSemiMajorAxis = (525+Consts.Req)/(1-initialEccentricity);
initialRightAscentionOfAscendingNode = deg2rad(47.8475);
initialArgumentOfPeriapsis = deg2rad(146.8877);
initialArgumentOfTrueAnomaly = 0;
approximateOrbitalPeriod = 2*pi*sqrt(initialSemiMajorAxis^3/Consts.mu);
chosenBridgeFunctionHandle = @bridgeToDepritSpace;


initialLeaderPosition = Position("COE",...
    {initialSemiMajorAxis,...
    initialEccentricity,...
    initialInclination,...
    initialRightAscentionOfAscendingNode,...
    initialArgumentOfPeriapsis,...
    initialArgumentOfTrueAnomaly});
leader = Satellite(initialLeaderPosition);


followerIntialDeltaFromLeaderCOE = Position("COE",{0,0,0,0,0,pi/3}).setWorldType("DEPRIT_KEPLER");
deltaV = Position("ECI",{0,0,0,-0.00022,-0.00022,0});



odeEvents = {0};
S = cell(2,1);


for index = 1:numel(S)
    follower = leader.applyDeltaInDepritKeplerWorld(followerIntialDeltaFromLeaderCOE, chosenBridgeFunctionHandle);
    if index==2
        follower = Satellite(follower.position.getAs("ECI").add(deltaV).getAs("PN"));
    end

    satellites = [leader,follower];
    numOfSatellites = length(satellites);

    S{index} = propMultiSatelliteStateSpace(...
        satellites,...
        timeVector,...
        odeEvents{1},...
        StateSpaceEnum.J2);

    [PolarNodalsRealSpaceSimResults,PolarNodalsDepritSimResults] = ...
        extractPositionsFromSolutions(S{index}, numOfSatellites, chosenBridgeFunctionHandle);

    dist{index} = physicalDistanceFromPolarNodals(PolarNodalsRealSpaceSimResults{1}, ...
        PolarNodalsRealSpaceSimResults{2});

    plot(timeVector/approximateOrbitalPeriod, dist{index}-dist{index}(1))
    hold on
end

