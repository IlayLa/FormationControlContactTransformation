function value = realAndDepritHamiltoniansEqualForLeader(~,y,~)
    positionVector = num2cell(y(1:Consts.numOfVarsInSS));
    position = Position("PN",positionVector);
    value = J2Hamiltonian(position) - DepritHamiltonian(position);
end