classdef PolarNodalVariablesEnum < int32
    enumeration
        r      (1)
        theta  (2)
        nu     (3)
        R      (4)
        Theta  (5)
        Nu     (6)
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