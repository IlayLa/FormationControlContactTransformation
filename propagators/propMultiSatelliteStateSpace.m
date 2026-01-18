function S = propMultiSatelliteStateSpace(satellites, timeVector, eventFunctions, stateSpaceEnum)



initialConditions = satellitesVectorToODEInitialConditions(satellites);

% ---- vectorize satellite dynamics ----
singleSatFcn = stateSpaceEnum.fn;     
multiSatFcn  = @(t, X) multiSatVectorized(t, X, singleSatFcn);

ode_def = ode;
ode_def.ODEFcn = multiSatFcn;
ode_def.InitialValue = initialConditions;
if isa(eventFunctions,"odeEvent")
    ode_def.EventDefinition = eventFunctions;
end
ode_def.Solver = "ode45";
ode_def.RelativeTolerance = Defaults.RelTolerance;
ode_def.AbsoluteTolerance = Defaults.AbsTolerance;
S = ode_def.solve(timeVector);
end

function dX = multiSatVectorized(t, X, singleSatFcn)
    % X is (6N × 1)
    % Reshape into 6×N
    Xmat = reshape(X, 6, []);

    % Apply function to each satellite
    % Using implicit expansion: f(t, Xmat(:,k)) returns 6×1, so:
    dXmat = singleSatFcn(t, Xmat);

    % Convert back to vector
    dX = dXmat(:);
end