function [eventFunctions, postActions, mem0] = hamiltonianMatchingSequenceDefinition(numOfPulses,chosenBridgeFunctionHandle)
    arguments (Input)
        numOfPulses {mustBeInteger}
        chosenBridgeFunctionHandle function_handle
    end
    % Define event sequence
    eventFunctions = repmat({
        @realAndDepritHamiltoniansEqualForLeader;
        @(t,y,mem) followerReachedLeadersEqualityTrueAnomaly(t,y,mem,chosenBridgeFunctionHandle);
        },numOfPulses,1);

    % Define post-event actions
    postActions = repmat({
        @(t, y, mem) storeLeaderInformationForFollowerPulse(t, y, mem, chosenBridgeFunctionHandle);
        @(t, y, mem) MatchHamiltonian(t, y, mem, chosenBridgeFunctionHandle);
    },numOfPulses,1);

    % Initial memory
    mem0 = struct('leaderTrueAnomalyAtHamiltonianEquality',0.0,"leaderHamiltonianValue",0.0);
end