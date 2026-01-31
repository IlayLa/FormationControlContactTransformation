function depritHamil = DepritHamiltonian(position)
arguments (Input)
    position Position
end

[r,~,~,R,Theta,Nu] = position.getAs("PN").positionVector{:};
[~,ecc,~,~,~,aota] = position.getAs("COE").positionVector{:};



k = -Consts.J2*(Consts.Req^2)/2;
c = Nu/Theta;
p = r*(1+ecc*cos(aota));

depritHamil = KeplerHamiltonian(r,R,Theta) ...
    + k*Consts.mu*(1-3*c^2)/(2*p*r^2);

end