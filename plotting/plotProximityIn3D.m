function plotProximityIn3D( ...
    basePosition, ...
    dims, ...
    desiredValue, ...
    funcHandle, ...
    ranges, ...
    nPoints, ...
    maxDeviation)

arguments
    basePosition (1,1) Position
    dims (1,3) ECIVariablesEnum
    desiredValue (1,1) double
    funcHandle (1,1) function_handle
    ranges (3,2) double
    nPoints (1,1) double {mustBeInteger, mustBePositive} = 30
    maxDeviation (1,1) double = Inf
end
basePosition = basePosition.getAs("ECI");
% --- Build grids ---
v1 = linspace(ranges(1,1), ranges(1,2), nPoints);
v2 = linspace(ranges(2,1), ranges(2,2), nPoints);
v3 = linspace(ranges(3,1), ranges(3,2), nPoints);

[V1, V2, V3] = ndgrid(v1, v2, v3);

numSamples = numel(V1);
values = zeros(numSamples,1);

baseVec = basePosition.positionVector;
V1 = baseVec{dims(1)} + V1;
V2 = baseVec{dims(2)} + V2;
V3 = baseVec{dims(3)} + V3;


% --- Evaluate function ---
for k = 1:numSamples
    vec = baseVec;

    vec{dims(1)} = V1(k);
    vec{dims(2)} = V2(k);
    vec{dims(3)} = V3(k);

    p = Position(basePosition.coordinateSystemType, vec);
    values(k) = funcHandle(p);
end

% --- Proximity metric ---
proximity = abs(values - desiredValue);

% --- Scrub far points ---
mask = proximity <= maxDeviation;

V1p = V1(mask);
V2p = V2(mask);
V3p = V3(mask);
proxP = proximity(mask);

% --- Plot ---
figure;
scatter3( ...
    V1p(:), V2p(:), V3p(:), ...
    36, proxP, 'filled');
hold on;

% --- Initial position marker ---
x0 = baseVec{dims(1)};
y0 = baseVec{dims(2)};
z0 = baseVec{dims(3)};

scatter3( ...
    x0, y0, z0, ...
    200, ...
    'p', ...
    'filled', ...
    'MarkerFaceColor', 'w', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1.5);

% --- Cosmetics ---
colormap(turbo);
cb = colorbar;
cb.Label.String = sprintf('|f(position) - %.3g|', desiredValue);

xlabel(dims(1).label(), 'Interpreter','none');
ylabel(dims(2).label(), 'Interpreter','none');
zlabel(dims(3).label(), 'Interpreter','none');

title('Function proximity in space');

legend({'Sampled points','Initial position'}, 'Location','best');

grid on;
axis tight;
view(45,30);

hold off;

end