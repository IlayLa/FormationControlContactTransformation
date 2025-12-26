classdef Position
    %COORDINATES Summary of this class goes here
    %   Detailed explanation goes here

    properties
        type CoordinateSystemEnum
        position (:,6)cell
    end

    methods
        function obj = Position(type, position)
            arguments (Input)
                type CoordinateSystemEnum
                position (:,6)cell
            end
            arguments (Output)
                obj Position
            end
            
            obj.type = type;
            obj.position = position;
        end


        function position = getAs(obj, type)
            arguments (Input)
                obj Position
                type CoordinateSystemEnum
            end
            arguments (Output)
                position Position
            end
            pos = convertCoordinateSystem(obj.position, obj.type, type);
            position = Position(type, pos);
        end

    end
end