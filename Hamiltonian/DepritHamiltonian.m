function depritHamil = DepritHamiltonian(position, currentcoordinateSystem)
position_PN = convertCoordinateSystem(position, currentcoordinateSystem, CoordinateSystemEnum.PN);
[r,~,~,R,Theta,Nu] = position_PN{:};


constantPart = Consts.J2.*Consts.mu.*(Consts.Req.^2);
depritHamil = KeplerHamiltonian(r,R,Theta) ...
    - constantPart.*(-1+3.*((Nu./Theta).^2))./(4.*r.^3);

end