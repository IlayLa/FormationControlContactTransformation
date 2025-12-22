function [r, theta, nu, R, Theta, Nu] = PNstartoPN(r, theta_star, nu_star, R, Theta_star, Nu, mu,J2,Req)
%only need to apply Halleys method on Theta, since
%d^2(nu,theta)/d(nu^2,theta^2) == 0
tol = 5e-11;
theta = zeros(size(theta_star));
nu = zeros(size(nu_star));
Theta = zeros(size(Theta_star));


for idx = 1:length(Theta_star)
Theta(idx) = Halleys_method(@(Theta) Theta_star_Func(Theta,Nu(idx),mu,J2,Req)-Theta_star(idx), ...
    @(Theta) diff_Theta_star_Func(Theta,Nu(idx),mu,J2,Req), ...
    @(Theta) diff2_Theta_star_Func(Theta,Nu(idx),mu,J2,Req),...
    tol,...
    Theta_star(idx));
end



for idx = 1:length(theta)
    theta(idx) = Newtons_Method(@(theta)  s_theta_star_Func(theta,Theta(idx),Nu(idx),mu,J2,Req)-theta_star(idx), ...
        @(theta) diff_s_theta_star_Func(Theta(idx),Nu(idx),mu,J2,Req),tol,theta_star(idx));
end

for idx = 1:length(nu)
    nu(idx) = Newtons_Method(@(nu)  nu_star_Func(theta(idx),nu,Theta(idx),Nu(idx),mu,J2,Req)-nu_star(idx), ...
        1,tol,nu_star(idx));
end

end






