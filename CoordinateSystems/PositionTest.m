classdef PositionTest < matlab.unittest.TestCase
    methods(Test)
        function testConstructorWithValidInputs(testCase)
            type = CoordinateSystemEnum.ECI;
            positionVector = {1, 2, 3, 4, 5, 6};

            obj = Position(type, positionVector);

            testCase.verifyEqual(obj.type, type);
            testCase.verifyEqual(obj.positionVector, positionVector);
        end

        function testGetAsConvertsCoordinates(testCase)
            type1 = CoordinateSystemEnum.ECI;
            type2 = CoordinateSystemEnum.PN;
            positionVector = {1, 0, 1, 10, 1, 0}; 

            obj = Position(type1, positionVector);
            convertedObj = obj.getAs(type2);

            expectedPosition = convertCoordinateSystem(positionVector, type1, type2); 
            testCase.verifyEqual(convertedObj.positionVector, expectedPosition);
            testCase.verifyEqual(convertedObj.type, type2);
        end

        function testGetAsWithInvalidType(testCase)
            type1 = CoordinateSystemEnum.ECI;
            positionVector = {1, 0, 1, 10, 1, 0}; 

            obj = Position(type1, positionVector);
            testCase.verifyError(@() obj.getAs('InvalidType'), 'MATLAB:validation:UnableToConvert'); 
        end

        function testGetAsWithInvalidPosition(testCase)
            type1 = CoordinateSystemEnum.ECI;
            positionVector = {[1,1], [0,0], [1,1], [10,1], [1,pi], [0,-1]}; 

            obj = Position(type1, positionVector);
            
            testCase.verifyError(@() obj.getAs('InvalidType'), 'MATLAB:validation:UnableToConvert'); 
        end
    end
end