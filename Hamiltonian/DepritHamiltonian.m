function depritHamil = DepritHamiltonian(position)
arguments (Input)
    position Position
end

[r,~,~,R,Theta,Nu] = position.getAs("PN").positionVector{:};


constantPart = Consts.J2.*Consts.mu.*(Consts.Req.^2);
depritHamil = KeplerHamiltonian(r,R,Theta) ...
    - constantPart.*(-1+3.*((Nu./Theta).^2))./(4.*r.^3);

end