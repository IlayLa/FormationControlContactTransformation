clc
close all
clearvars

syms t q p real
Xt = {t;q;p};
X = [q;p];
H = p^2+q^2;
gradH = gradient(H,X);
hessH = double(hessian(H,X));

gradH_ = matlabFunction(gradH,'Vars', {[q;p]});
Xdot = matlabFunction(Poisson_Bracket(X,H,X),'Vars', {[q;p]});
xdot = @(t,in1) Xdot(in1);

ode45(@(t,y) controlledStateSpace(t,y,xdot,gradH_,hessH), ...
    linspace(0,10,1e3),[2;0;sqrt(2);sqrt(2)],odeset('RelTol',1e-13,'AbsTol',1e-13));
% [~,dfy] = gradient(y(:,1:2),t(2)-t(1));

% plot(t,vecnorm(y(:,3:4)-y(:,1:2),2,2))
% plot(t, dot(arrayfun(gradH_, (y(:,1:2)'))',y(:,3:4)-y(:,1:2),2))
% plot(t, cumtrapz(t,abs(dot(repmat([1, -1],[1e3,1]),(y(:,1:2) - y(:,3:4)),2))))


function y = controlledStateSpace(~,y,xdot,gradH_,hessH)
follower_derivative = xdot(0,y(1:2));
leader_derivative = xdot(0,y(3:4));

follower_total = follower_derivative+follower_maneuver;

y = [follower_total;leader_derivative];
end
















