function value = followerReachedLeadersEqualityTrueAnomaly(~,y,memory)
    trueAnomalyTarget = memory.leaderTrueAnomalyAtHamiltonianEquality;
    followerPositionVector = num2cell(y((Consts.numOfVarsInSS+1):end));
    [followerPositionVectorCOE{1:6}] = PNtoCOE(followerPositionVector{:},Consts.mu);
    value = followerPositionVectorCOE{CanonicalOrbitalElementsEnum.AOTA}-trueAnomalyTarget;
end