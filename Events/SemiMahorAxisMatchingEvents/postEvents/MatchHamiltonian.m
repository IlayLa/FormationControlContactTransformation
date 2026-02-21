function [y_new, mem_new, customData] = MatchHamiltonian(~, y, mem, chosenBridgeFunctionHandle)
    followerPositionVector = num2cell(y((Consts.numOfVarsInSS+1):end));
    follower = Satellite(Position("PN",followerPositionVector));
    

    funct = @(x) optimizationMetric( Position("ECI",{0,0,0,x(1),x(2),x(3)}),...
    follower, chosenBridgeFunctionHandle, mem);
    options = optimset("TolFun", 1e-16);
    x = fminsearch(funct, [0, 0, 0], options);
    followerPositionVectorAfterDelta = follower.position.getAs("ECI").add(Position("ECI",{0,0,0,x(1),x(2),x(3)})).getAs("PN").positionVector;
    y_new = [y(1:6);[followerPositionVectorAfterDelta{:}]'];
    mem_new = mem;
    customData = 0;
end




function opt = optimizationMetric(dV,follower,bridgeFunction, mem)
    arguments (Input)
        dV Position
        follower Satellite
        bridgeFunction function_handle
        mem struct
    end
    
    if dV.coordinateSystemType ~= CoordinateSystemEnum.ECI
        error("deltaV must be in ECI")
    end

    followerPosition = follower.position.getAs("ECI").add(dV).getPositionInKeplerianDepritSpace(bridgeFunction);
    
    
    opt = abs(KeplerHamiltonian(followerPosition) - mem.leaderHamiltonianValue);

end
