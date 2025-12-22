function [r,v,h] = getRelevantECIVectors(position_ECI)
r = [position_ECI{1:3}];
v = [position_ECI{4:6}];
h = cross(r, v);
end