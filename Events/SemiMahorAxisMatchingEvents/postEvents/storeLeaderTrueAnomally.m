function [y, mem_new, customData] = storeLeaderTrueAnomally(~, y, mem)
    leaderPositionVector = num2cell(y(1:Consts.numOfVarsInSS));
    leaderPositionCOE = Position("PN",leaderPositionVector).getAs("COE");
    mem_new = mem;
    mem_new.leaderTrueAnomalyAtHamiltonianEquality = leaderPositionCOE.positionVector{CanonicalOrbitalElementsEnum.AOTA};
    mem_new.leaderHamiltonianValue = J2Hamiltonian(leaderPositionCOE);
    mem_new.leaderPosition = leaderPositionCOE;
    customData = 0;
end