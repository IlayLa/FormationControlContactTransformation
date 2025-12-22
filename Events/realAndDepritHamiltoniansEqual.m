function value = realAndDepritHamiltoniansEqual(~, y)

position = num2cell(y); 
value = J2Hamiltonian(position, CoordinateSystemEnum.PN) - DepritHamiltonian(position, CoordinateSystemEnum.PN);
end