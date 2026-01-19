function j2Hamil = J2Hamiltonian(position)
arguments (Input)
    position Position
end
[r,theta,~,R,Theta,Nu] = position.getAs("PN").positionVector{:};

constantPart = Consts.mu.*Consts.J2.*Consts.Req.^2;

j2Hamil = -constantPart.*(1-3.*sin(theta).^2.*(1-(Nu./Theta).^2))./(2.*r.^3)...
    + KeplerHamiltonian(r,R,Theta);
end
