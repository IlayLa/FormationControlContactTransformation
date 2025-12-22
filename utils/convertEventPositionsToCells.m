function [numOfEvents,eventPositions] = convertEventPositionsToCells(positions)
numOfEvents = length(positions);
eventPositions = mat2cell(positions,6,ones(1,numOfEvents));
end