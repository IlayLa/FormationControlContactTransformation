function satellitesVector = createLeaderAndFollowerSatelliteVector(initialLeaderPosition,followerIntialDeltaFromLeaderCOEinDeprit, bridgeFunction)
arguments (Input)
    initialLeaderPosition Position
    followerIntialDeltaFromLeaderCOEinDeprit(6,1)cell
    bridgeFunction function_handle
end

leader = Satellite(initialLeaderPosition);

leaderDepritKeplerianSpaceInitialConditions = leader.position.getPositionInKeplerianDepritSpace(bridgeFunction);

follower_COEsDepritKeplerianSpaceInitialConditions =...
    leaderDepritKeplerianSpaceInitialConditions.getAs("COE").positionVector;


for index = 1:Consts.numOfVarsInSS
    follower_COEsDepritKeplerianSpaceInitialConditions{index} ...
        = follower_COEsDepritKeplerianSpaceInitialConditions{index}...
        + followerIntialDeltaFromLeaderCOEinDeprit{index};
end
follower_PNInJ2RealSpaceInitialConditions =...
    KeplerianAveragedSpaceToJ2RealSpace(...
    follower_COEsDepritKeplerianSpaceInitialConditions, ...
    CoordinateSystemEnum.COE, ...
    bridgeFunction);


follower = Satellite(follower_PNInJ2RealSpaceInitialConditions,...
    CoordinateSystemEnum.PN);
satellitesVector = [leader,follower];
end