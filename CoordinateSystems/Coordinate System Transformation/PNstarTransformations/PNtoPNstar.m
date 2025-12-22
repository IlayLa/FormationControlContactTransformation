function [r, theta_star, nu_star, R, Theta_star, Nu] = PNtoPNstar(r, theta, nu, R, Theta, Nu, mu,J2,Req)
%PNtoPNstar
%    [r, theta_star, nu_star, R, Theta_star, Nu] = Theta_star_Func(r, theta, nu, R, Theta, Nu, mu,J2,Req)

nu_star = nu_star_Func(theta,nu,Theta,Nu,mu,J2,Req);
theta_star = s_theta_star_Func(theta,Theta,Nu,mu,J2,Req);
Theta_star = Theta_star_Func(Theta,Nu,mu,J2,Req);
end

