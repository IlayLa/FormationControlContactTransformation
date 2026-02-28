function value = followerReachedLeadersEqualityTrueAnomaly(~,y,memory, chosenBridgeFunctionHandle)
    trueAnomalyTarget = memory.leaderTrueAnomalyAtHamiltonianEquality;
    followerPositionVector = num2cell(y((Consts.numOfVarsInSS+1):end));
    followerPosition = Position("PN", followerPositionVector);
    value = followerPosition.getPositionInKeplerianDepritSpace(chosenBridgeFunctionHandle).getAs("COE").positionVector{CanonicalOrbitalElementsEnum.AOTA}-trueAnomalyTarget;
end