function [outputArg1,outputArg2] = plotHamiltonianOver2Variables(position, ...
    currentCoordinateSystem, var1, range1, var2, range2, hamiltonianFunction)
initialPosition_PN = convertCoordinateSystem(position, currentCoordinateSystem, CoordinateSystemEnum.PN);
position_PN = initialPosition_PN;

H0 = hamiltonianFunction(position_PN, CoordinateSystemEnum.PN);
[X, Y] = meshgrid(range1, range2);

H = zeros(size(X));
for index = 1:numel(X)
    position_PN{int32(var1)} = X(index);
    position_PN{int32(var2)} = Y(index);
    H(index) = hamiltonianFunction(position_PN, CoordinateSystemEnum.PN);
end

surf(X,Y,H-H0,'EdgeColor','none')
hold on 
surf(X,Y,zeros(size(X)),'EdgeColor','none')
plot(initialPosition_PN{int32(var1)}, ...
     initialPosition_PN{int32(var2)}, ...
     "Color","magenta","Marker","o","MarkerSize",12,"LineWidth",3)



xlabel(string(var1))
ylabel(string(var2))


end