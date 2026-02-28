function [y, mem_new, customData] = storeLeaderInformationForFollowerPulse(~, y, mem, chosenBridgeFunctionHandle)
    % Store leader's true anomaly and hamiltonian value for the eventual pulse action by follower, these are taken in deprit keplerian space
    leaderPositionVector = num2cell(y(1:Consts.numOfVarsInSS));
    leaderPositionCOE = Position("PN",leaderPositionVector).getPositionInKeplerianDepritSpace(chosenBridgeFunctionHandle).getAs("COE"); % TODO: fix hard coded bridge function - HSC-010
    mem_new = mem;
    mem_new.leaderTrueAnomalyAtHamiltonianEquality = leaderPositionCOE.positionVector{CanonicalOrbitalElementsEnum.AOTA};
    mem_new.leaderHamiltonianValue = KeplerHamiltonian(leaderPositionCOE);
    mem_new.leaderPosition = leaderPositionCOE;
    customData = 0;
end