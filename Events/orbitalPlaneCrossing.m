function value = orbitalPlaneCrossing(~,y)
perpendicularity_tolerance = 5e-7;

[y_kep_PN1, ~] = J2RealSpaceToAveragedSpace(num2cell(y(1:6)),CoordinateSystemEnum.PN);
[y_kep_PN2, ~] = J2RealSpaceToAveragedSpace(num2cell(y(7:12)),CoordinateSystemEnum.PN);

y_ECI1 = convertCoordinateSystem(y_kep_PN1, CoordinateSystemEnum.PN, CoordinateSystemEnum.ECI);

y_ECI2 = convertCoordinateSystem(y_kep_PN2, CoordinateSystemEnum.PN, CoordinateSystemEnum.ECI);



r1 = cell2mat(y_ECI1(1:3));
v1 = cell2mat(y_ECI1(4:6));
r2 = cell2mat(y_ECI2(1:3));
h1 = cross(r1,v1);
value = abs(dot(r2,h1)./(norm(r2).*norm(h1))) - perpendicularity_tolerance;




end