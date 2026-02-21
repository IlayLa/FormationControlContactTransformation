function j2Hamil = J2Hamiltonian(position)
arguments (Input)
    position Position
end
[r,theta,~,R,Theta,Nu] = position.getAs("PN").positionVector{:};


k = -Consts.J2*(Consts.Req^2)/2;
c = Nu/Theta;
s = sqrt(1-c^2);



j2Hamil = k*Consts.mu*(3*(s^2)*(sin(theta)^2)-1)/(r^3)...
    + KeplerHamiltonian(position);
end
