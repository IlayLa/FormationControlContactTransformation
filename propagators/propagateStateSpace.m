function [timeVector, PolarNodalsRealSpaceSimResults, S] = propagateStateSpace( ...
    initialConditions, initialConditionsCoordinateSystem, timeVector, eventFunctions, stateSpace)

initialConditions = ...
    convertCoordinateSystem(initialConditions, initialConditionsCoordinateSystem,...
    CoordinateSystemEnum.PN);


ode_def = ode;
ode_def.ODEFcn = stateSpace;
ode_def.InitialValue = cell2mat(initialConditions)';
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