function value = stopAtPeriapsis(~, y)
y = num2cell(y);
y_COE = convertCoordinateSystem(y,CoordinateSystemEnum.PN, CoordinateSystemEnum.COE);


value = y_COE{6};
end