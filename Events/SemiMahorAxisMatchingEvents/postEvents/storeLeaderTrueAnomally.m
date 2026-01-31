function [y, mem_new, customData] = storeLeaderTrueAnomally(~, y, mem)
    leaderPositionVector = num2cell(y(1:Consts.numOfVarsInSS));
    leaderPositionCOE = Position("PN",leaderPositionVector).getAs("COE");
    mem_new = mem;
    mem_new.leaderTrueAnomalyAtHamiltonianEquality = leaderPositionCOE.positionVector{CanonicalElementsEnum.AOTA};
    mem_new.leaderHamiltonianValue = J2Hamiltonian(leaderPositionCOE);
    customData = 0;
end