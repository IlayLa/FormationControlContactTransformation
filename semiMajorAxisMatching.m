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
follower = leader.applyDeltaInDepritKeplerWorld(followerIntialDeltaFromLeaderCOE,...
 chosenBridgeFunctionHandle);




 


leaderDepritKeplerSemiMajorAxis = leader.position.getPositionInKeplerianDepritSpace(chosenBridgeFunctionHandle).positionVector{1};

followerDepritKeplerSemiMajorAxis = follower.position.getPositionInKeplerianDepritSpace(chosenBridgeFunctionHandle).positionVector{1};

deltaVelocity = Position("ECI",{0,0,0,0,0,0});
funct = @(vx,vy) optimizationMetric( Position("ECI",{0,0,0,vx,vy,0}),...
 follower, chosenBridgeFunctionHandle, leader);


lim = 0.00001;
num = 101;

vx = linspace(-lim,lim,num);
vy = vx;

solutions = zeros(num);

for idx = 1:num
    for jdx = 1:num
        solutions(idx,jdx) = funct(vx(idx),vy(jdx));
    end
end
% mesh(vx, vy, solutions)
% hold on
minSol = min(solutions,[],"all");
% plot3(vx(I(1)),vy(I(2)),solutions(I(1),I(2)),"Marker","o","MarkerSize",12)
[r,c] = find(solutions==minSol);
VX = vx(r)
VY = vy(c)


function opt = optimizationMetric(dV,sat,bridgeFunction,leader)
    arguments (Input)
        dV Position
        sat Satellite
        bridgeFunction function_handle
        leader Satellite
    end
    
    if dV.coordinateSystemType ~= CoordinateSystemEnum.ECI
        error("deltaV must be in ECI")
    end

    followerPositionVector = sat.position.getAs("ECI").add(dV)...
    .getPositionInKeplerianDepritSpace(bridgeFunction).positionVector;
    leaderPositionVector = leader.position.getPositionInKeplerianDepritSpace(bridgeFunction).positionVector;
    
    opt = abs(followerPositionVector{CanonicalElementsEnum.SMA}-leaderPositionVector{CanonicalElementsEnum.SMA})/leaderPositionVector{CanonicalElementsEnum.SMA}... 
    + abs(followerPositionVector{CanonicalElementsEnum.INC}-leaderPositionVector{CanonicalElementsEnum.INC})/leaderPositionVector{CanonicalElementsEnum.INC}...
    + abs(followerPositionVector{CanonicalElementsEnum.ECC}-leaderPositionVector{CanonicalElementsEnum.ECC})/leaderPositionVector{CanonicalElementsEnum.ECC};


end













