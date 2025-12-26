clc
close all
clear
format longG
addpath(genpath('C:\MatlabDrive\Masters_Stuff\FormationControlContactTransformation'));


minute = 60;
hour = 60*minute;
day = 24*hour;
year = 365*day;
maxTime = day*2;
timeVector = linspace(0,maxTime, 1e3+1);
% initial conditions in COEs J2 real space
ecc0 = 0.0002542;
inc0 = deg2rad(28.4704);
sma0 = (525+Consts.Req)/(1-ecc0);
raan0 = deg2rad(47.8475);
aop0 = deg2rad(146.8877);
aota0 = 0;
approximateOrbitalPeriod = 2*pi*sqrt(sma0^3/Consts.mu);

COE0 = Position("COE",{sma0,ecc0,inc0,raan0,aop0,aota0});
leader = Satellite(COE0);

[~, COEsDepritKeplerianSpaceInitialConditions, bridge] ...
    = J2RealSpaceToAveragedSpace(...
    leader.position);

follower_COEsDepritKeplerianSpaceInitialConditions =...
    COEsDepritKeplerianSpaceInitialConditions;

followerIntialDeltaFromLeaderCOE = {0,0,0,0,0,pi/3};

for index = 1:Consts.numOfVarsInSS
    follower_COEsDepritKeplerianSpaceInitialConditions{index} ...
        = follower_COEsDepritKeplerianSpaceInitialConditions{index}...
        + followerIntialDeltaFromLeaderCOE{index};
end
follower_PNInJ2RealSpaceInitialConditions =...
    KeplerianAveragedSpaceToJ2RealSpace(...
    follower_COEsDepritKeplerianSpaceInitialConditions, ...
    CoordinateSystemEnum.COE);


follower = Satellite(follower_PNInJ2RealSpaceInitialConditions,...
    CoordinateSystemEnum.PN);

Satellites = [leader,follower];
numOfSatellites = length(Satellites);

numOfEvents = 101;
eventTimeVector = linspace(1e-1,maxTime-1,numOfEvents);
blueWorldTimeEvents = cell(size(eventTimeVector));
for index = 1:numOfEvents
    blueWorldTimeEvents{index} = odeEvent( ...
        "EventFcn", @(t,y) timeEvent(t,y,eventTimeVector(index)),...
        "Direction", matlab.ode.EventDirection.both, ...
        "Response", matlab.ode.EventAction.callback,...
        "CallbackFcn", @blueWorldOrbitalPeriodMatching ...
        );
end
odeEvents = [blueWorldTimeEvents(:)'];

% S = cell(numel(odeEvents),1);
dist = cell(numel(odeEvents),1);

for index = 1:numel(odeEvents)
    S = propMultiSatelliteStateSpace(...
        Satellites,...
        timeVector,...
        odeEvents{index},...
        StateSpaceEnum.J2);

    [PolarNodalsRealSpaceSimResults,PolarNodalsDepritSimResults] = ...
        extractPositionsFromSolutions(S,numOfSatellites);

    dist{index} = physicalDistanceFromPolarNodals(PolarNodalsRealSpaceSimResults{1}, ...
        PolarNodalsRealSpaceSimResults{2});

    if index > 1
        plotName = "time of event: "+eventTimeVector(index-1) + " [s]";
    else
        plotName = "no event";
    end
    % plot(timeVector/approximateOrbitalPeriod, dist{index}-dist{index}(1), "DisplayName",plotName)
    % hold on
end
% title("distance over time")
% ylabel("distance [km]")
% xlabel("approximate orbit ")
% xline(0:max(int32(timeVector/approximateOrbitalPeriod)))

COERealSpaceSimResults = ...
    cellfun(...
    @(pos) ...
    convertCoordinateSystem(pos,CoordinateSystemEnum.PN, ...
    CoordinateSystemEnum.COE), ...
    PolarNodalsRealSpaceSimResults, "UniformOutput",false ...
    );
[~, CEODepritSimResults] = ...
    cellfun(...
    @(pos) J2RealSpaceToAveragedSpace(pos,CoordinateSystemEnum.PN), ...
    PolarNodalsRealSpaceSimResults, "UniformOutput",false ...
    );


%%
figure
orbitalElement = CanonicalOrbitalElementsEnum.INC;
plot(timeVector/hour,CEODepritSimResults{1}{orbitalElement})
hold on
plot(timeVector/hour,CEODepritSimResults{2}{orbitalElement})


%%
distJumps = zeros(size(eventTimeVector));
for index = 1:length(eventTimeVector)
    indices = find(timeVector>eventTimeVector(index),1)+[-1,0];
    distJumps(index) = diff(dist{index}(indices)); 
end
plot(eventTimeVector/approximateOrbitalPeriod, distJumps, 'or')






