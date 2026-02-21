classdef ECIVariablesEnum < int32
    enumeration
        x    (1) % 
        y    (2) % 
        z    (3) % 
        X    (4) % 
        Y    (5) % 
        Z    (6) % 
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