function S = runningEventSequenceWrapper(sma0,ecc0,inc0,raan0,aop0,aota0,initialAOTADelta,chosenBridgeFunctionHandle,eventFunctions,postActions,mem0,timeVector)
initialLeaderPosition = Position("COE",{sma0,ecc0,inc0,raan0,aop0,aota0});
leader = Satellite(initialLeaderPosition);

followerIntialDeltaFromLeaderCOE = Position("COE",{0,0,0,0,0,initialAOTADelta}).setWorldType("DEPRIT_KEPLER");


follower =...
    Satellite(...
    leader.position.getPositionInKeplerianDepritSpace(chosenBridgeFunctionHandle)...
    .add (followerIntialDeltaFromLeaderCOE)...
    .getPositionInFullJ2World(chosenBridgeFunctionHandle));


satellites = [leader,follower];

initialConditions = satellitesVectorToODEInitialConditions(satellites);



% Create propagator - specify event directions
prop = EventSequencePropagator(@(t,y,mem) vectorizedStateSpace(@(t,y) j2StateSpace(t,y, Consts.mu,Consts.J2,Consts.Req), t, y), eventFunctions, postActions, mem0);


S = prop.solve(timeVector,initialConditions, "Hamiltonian Matching Sequence");
end