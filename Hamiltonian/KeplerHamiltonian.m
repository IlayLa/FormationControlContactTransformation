function K = KeplerHamiltonian(r,R,Theta)
K = 0.5.*(R.^2+(Theta./r).^2)-Consts.mu./r;
end