function PM = poissonMatrix(coordinateVector, secondCoordinateVector, basisCoordinateVector)
PM = zeros(length(coordinateVector),length(secondCoordinateVector));

for idx = 1:length(coordinateVector)
    for jdx = 1:length(secondCoordinateVector)
        PM(idx,jdx) = Poisson_Bracket(coordinateVector(idx), secondCoordinateVector(jdx), basisCoordinateVector);
    end
end

end