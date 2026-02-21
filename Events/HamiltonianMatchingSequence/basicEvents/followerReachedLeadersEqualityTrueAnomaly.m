function value = followerReachedLeadersEqualityTrueAnomaly(~,y,memory)
    trueAnomalyTarget = memory.leaderTrueAnomalyAtHamiltonianEquality;
    followerPositionVector = num2cell(y((Consts.numOfVarsInSS+1):end));
    followerPosition = Position("PN", followerPositionVector);
    value = followerPosition.getPositionInKeplerianDepritSpace(@bridgeToDepritSpace).getAs("COE").positionVector{CanonicalOrbitalElementsEnum.AOTA}-trueAnomalyTarget;
end