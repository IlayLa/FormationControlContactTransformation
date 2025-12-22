function [sma, ecc, inc, Omega, omega, nu] = ECItoCOE(x,y,z,X,Y,Z,mu)
isSym = isa(x,"sym");
if isSym
r_vec = [x,y,z];
v_vec = [X,Y,Z];
r = norm(r_vec);
v = norm(v_vec);
h_vec = cross(r_vec,v_vec);
h = norm(h_vec);

else
r_vec = [x,y,z];
v_vec = [X,Y,Z];
r = vecnorm(r_vec,2,2);
v = vecnorm(v_vec,2,2);
h_vec = cross(r_vec,v_vec,2);
h = norm(h_vec);
end
n_vec = [-h_vec(:,2),h_vec(:,1),zeros(size(h_vec(:,1)))];

energy = v.^2./2 - mu./r;
ecc_vec = ((v.^2-mu./r).*r_vec - (dot(r_vec,v_vec,2)).*v_vec)./mu;
h_hat = h_vec./h;
%semi major axis
sma = -mu./(2*energy);

%eccentricity
if isSym
ecc = norm(ecc_vec);
else
ecc = vecnorm(ecc_vec,2,2);
end    
%inclination
inc = acos(h_vec(:,3)./h);

% Right ascention of ascending node
Omega = atan2(n_vec(:,2),n_vec(:,1));


% Argument of periapsis
if isSym
omega = atan2( dot(h_hat, cross(n_vec, ecc_vec, 2)), dot(n_vec, ecc_vec));
else
omega = atan2( dot(h_hat, cross(n_vec, ecc_vec, 2), 2), dot(n_vec, ecc_vec, 2) );
end

% true anomaly
if isSym
nu = atan2( dot(h_hat, cross(ecc_vec,r_vec, 2)), dot(r_vec,ecc_vec) );
else
nu = atan2( dot(h_hat, cross(ecc_vec,r_vec, 2), 2), dot(r_vec,ecc_vec, 2) );
end
end

