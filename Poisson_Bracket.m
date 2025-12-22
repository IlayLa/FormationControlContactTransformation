function PBR = Poisson_Bracket(X,b,C)
L = length(C);
PBR = sym(zeros(size(X)));
for idx = 1:length(X)
    a = X(idx);
    for jdx = 1:L/2
        PBR(idx) = PBR(idx)+Lie_Derivative(a,b,C,jdx,L);
    end
end
end
