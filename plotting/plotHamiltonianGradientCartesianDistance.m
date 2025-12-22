function plotHamiltonianGradientCartesianDistance(fullSolutions, doFullSolution)
if (isa(doFullSolution,"logical") & doFullSolution)
    positions = fullSolutions.Solution;
    time = fullSolutions.Time; % Extract time for plotting
else 
    positions = fullSolutions.EventSolution;
    time = fullSolutions.EventTime;
end
[numOfEvents,eventPositions] = convertEventPositionsToCells(positions);

distanceBetweenGradients = zeros(1,numOfEvents);
for chosenEventIndex = 1:numOfEvents
    chosenEventPosition = num2cell(eventPositions{chosenEventIndex});
    j2GradientValue = j2Gradient(chosenEventPosition{:},Consts.mu,Consts.J2,Consts.Req);
    [PolarNodalsDepritKeplerianSpace, ~] = J2RealSpaceToAveragedSpace(chosenEventPosition,CoordinateSystemEnum.PN);
    depritGradientValue = depritGradient(PolarNodalsDepritKeplerianSpace{:},Consts.mu,Consts.J2,Consts.Req);
    distanceBetweenGradients(chosenEventIndex) = norm(j2GradientValue - depritGradientValue);
end

plot(time, distanceBetweenGradients)
end