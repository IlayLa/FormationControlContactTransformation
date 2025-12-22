function [Lietransform,n] = Lie_Transform(Coordinates,Generating_function,order,additional_variable)
t = additional_variable;
Lietransform = Coordinates;
Deriv = Poisson_Bracket(Coordinates,Generating_function,Coordinates);

n = 0;
while (any(logical(Deriv ~= 0)) && n <order)
    n=n+1;
    Lietransform = Lietransform+(t^n/(factorial(n)))*Deriv;
    fprintf("currently calculating order %d\n",n);
    tic
    Deriv = Poisson_Bracket((Deriv),Generating_function,Coordinates);
    toc
end
end


