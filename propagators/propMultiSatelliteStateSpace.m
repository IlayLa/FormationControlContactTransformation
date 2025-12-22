function S = propMultiSatelliteStateSpace(satellites, timeVector, eventFunctions, stateSpaceEnum)
numOfSatellites = length(satellites);
initialConditions = zeros(numOfSatellites,1);
for index = 1:numOfSatellites
    polarNodalPositionCell = satellites(index).getPolarNodal();
    initialConditions(((index-1)*6+1):index*6) = [polarNodalPositionCell{:}];
end
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
timeVector = S.Time;
Y = S.Solution';

PolarNodalsRealSpaceSimResults = mat2cell(Y(:,1:6),length(timeVector),ones(1,6));

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