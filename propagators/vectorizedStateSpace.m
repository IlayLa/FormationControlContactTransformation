function dY = vectorizedStateSpace(stateFcn, t, y)
    N = numel(y)/Consts.numOfVarsInSS;
    if mod(N,1)~=0 
        error("input has wrong number of items to be describing an integer number of satellites")
    end
    
    dY = zeros(size(y));


    for k = 0:(N-1)
        indices =  (Consts.numOfVarsInSS*k+1):(Consts.numOfVarsInSS*(k+1));
        dY(indices) = stateFcn(t, y(indices));
    end
end