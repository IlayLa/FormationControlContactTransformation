clc
close all
clearvars
coe = [7000, 0.1, 1.0, 1.0, 1.0, 1.0]


G = gaussVariationalEquations(coe, Consts.mu)

delta = 0.1;
deltaVMag = delta/norm(G(3,:))
deltaV = G(3,:)*deltaVMag/norm(G(3,:))


X = cell2mat(convertCoordinateSystem(num2cell(coe),CoordinateSystemEnum.COE, CoordinateSystemEnum.ECI))
r = X(1:3)/norm(X(1:3))
v = X(4:6)/norm(X(4:6))
h = cross(r,v)
DirectionalMat = [r;v;h]
X(4:6) = X(4:6) + deltaV*DirectionalMat

coe = cell2mat(convertCoordinateSystem(num2cell(X), CoordinateSystemEnum.ECI, CoordinateSystemEnum.COE))













