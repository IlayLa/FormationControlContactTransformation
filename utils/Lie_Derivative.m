function LB = Lie_Derivative(a,b,C,idx,L)
LB = diff(a,C(idx))*diff(b,C(idx+L/2))-diff(b,C(idx))*diff(a,C(idx+L/2));
end
