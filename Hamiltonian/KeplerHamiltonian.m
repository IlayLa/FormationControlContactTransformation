function K = KeplerHamiltonian(position)
    arguments (Input)
        position Position
    end
    position_PN = position.getAs("PN");
    [r,~,~,R,Theta,~] = position_PN.positionVector{:};
    K = 0.5.*(R.^2+(Theta./r).^2)-Consts.mu./r;
end