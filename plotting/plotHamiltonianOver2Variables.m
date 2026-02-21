function plotHamiltonianOver2Variables(position, var1, range1, var2, range2, hamiltonianFunction, levelToContour)
arguments (Input)
    position Position
    var1 ECIVariablesEnum
    range1 (1,:){mustBeNumeric}
    var2 ECIVariablesEnum
    range2 (1,:){mustBeNumeric}
    hamiltonianFunction function_handle
    levelToContour (1,1){mustBeNumeric}
end

initialPosition_ECI = position.getAs("ECI").positionVector;
position_ECI = initialPosition_ECI;

[X, Y] = meshgrid(range1, range2);
X = initialPosition_ECI{int32(var1)} + X;
Y = initialPosition_ECI{int32(var2)} + Y;
H = zeros(size(X));
for index = 1:numel(X)
    position_ECI{int32(var1)} =  X(index);
    position_ECI{int32(var2)} =  Y(index);
    H(index) = hamiltonianFunction(Position("ECI",position_ECI));
end

surfdata = surf(X,Y,H,'EdgeColor','none');
hold on 
contour3(X,Y,H,[levelToContour, levelToContour],EdgeColor="red",LineWidth=2)
grid on
plot3(initialPosition_ECI{int32(var1)}, ...
     initialPosition_ECI{int32(var2)}, ...
     hamiltonianFunction(position), ...
     "Color","magenta","Marker","o","MarkerSize",12,"LineWidth",3)



xlabel(string(var1))
ylabel(string(var2))


end