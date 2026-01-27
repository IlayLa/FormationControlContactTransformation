classdef CanonicalElementsEnum < int32
    enumeration
        SMA    (1) % Semi Major Axis
        ECC    (2) % Eccentricity
        INC    (3) % Inclination
        RAAN   (4) % Right Ascention of the Ascending Node
        AOP    (5) % Argument of Perigee 
        AOTA   (6) % Argument of True Anomaly
    end

    methods
        function idx = index(obj)
            idx = int32(obj);
        end
        function s = label(obj)
            s = char(obj);
        end
    end
end