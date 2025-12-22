classdef CanonicalOrbitalElementsEnum < int32
    enumeration
        SMA      (1)
        ECC  (2)
        INC     (3)
        RAAN      (4)
        AOP  (5)
        AOTA     (6)
    end

    methods
        function idx = index(obj)
            idx = int32(obj);
        end
        function s = label(obj)
            s = char(obj);
        end
        function rng = defaultRange(obj)
            % all your defaults here
        end
    end
end