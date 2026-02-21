clc
close all
clear
format longG
addpath(genpath('./'));
disp("hi")

minute = 60;
hour = 60*minute;
day = 24*hour;
year = 365*day;
maxTime = day*30;
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


followerIntialDeltaFromLeaderCOE = Position("COE",{0,0,0,0,0,-pi*0.5}).setWorldType("DEPRIT_KEPLER");
follower = leader.applyDeltaInDepritKeplerWorld(followerIntialDeltaFromLeaderCOE,...
 chosenBridgeFunctionHandle);




 


leaderDepritKeplerSemiMajorAxis = leader.position.getPositionInKeplerianDepritSpace(chosenBridgeFunctionHandle).positionVector{1};

followerDepritKeplerSemiMajorAxis = follower.position.getPositionInKeplerianDepritSpace(chosenBridgeFunctionHandle).positionVector{1};

funct = @(x) optimizationMetric( Position("ECI",{0,0,0,x(1),x(2),x(3)}),...
 follower, chosenBridgeFunctionHandle, leader);


 options = optimset('PlotFcns',@optimplotfval,"TolFun", 1e-8);
[x,fval,exitflag,output] = fminsearch(funct, [0, 0, 0], options);


fprintf("%g,%g,%g\n",x(1),x(2),x(3))

fprintf("%g [m/s]",norm(x)*1000)


function opt = optimizationMetric(dV,follower,bridgeFunction,leader)
    arguments (Input)
        dV Position
        follower Satellite
        bridgeFunction function_handle
        leader Satellite
    end
    
    if dV.coordinateSystemType ~= CoordinateSystemEnum.ECI
        error("deltaV must be in ECI")
    end

    followerPosition = follower.position.getAs("ECI").add(dV)...
    .getPositionInKeplerianDepritSpace(bridgeFunction);
    leaderPosition = leader.position.getPositionInKeplerianDepritSpace(bridgeFunction);
    
    opt = abs(DepritHamiltonian(followerPosition) - DepritHamiltonian(leaderPosition));

end

function metric = calcRelativeMetric(followerPositionVector, leaderPositionVector, CanonicalOrbitalElementsEnum)
    arguments (Input)
        followerPositionVector (1,6)cell 
        leaderPositionVector (1,6)cell
        CanonicalOrbitalElementsEnum CanonicalOrbitalElementsEnum
    end
    arguments (Output)
        metric {mustBeNumeric} 
    end
    metric = abs(followerPositionVector{CanonicalOrbitalElementsEnum}-leaderPositionVector{CanonicalOrbitalElementsEnum})/leaderPositionVector{CanonicalOrbitalElementsEnum};
end











