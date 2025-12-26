classdef PositionTest < matlab.unittest.TestCase
    methods(Test)
        function testConstructorWithValidInputs(testCase)
            type = CoordinateSystemEnum.ECI;
            position = {1, 2, 3, 4, 5, 6};

            obj = Position(type, position);

            testCase.verifyEqual(obj.type, type);
            testCase.verifyEqual(obj.position, position);
        end

        function testGetAsConvertsCoordinates(testCase)
            type1 = CoordinateSystemEnum.ECI;
            type2 = CoordinateSystemEnum.PN;
            position = {1, 0, 1, 10, 1, 0}; 

            obj = Position(type1, position);
            convertedObj = obj.getAs(type2);

            expectedPosition = convertCoordinateSystem(position, type1, type2); 
            testCase.verifyEqual(convertedObj.position, expectedPosition);
            testCase.verifyEqual(convertedObj.type, type2);
        end

        function testGetAsWithInvalidType(testCase)
            type1 = CoordinateSystemEnum.Cartesian;
            position = {1, 0, 1, 10, 1, 0}; 

            obj = Position(type1, position);
            testCase.verifyError(@() obj.getAs('InvalidType'), 'MATLAB:invalidType'); 
        end
    end
end