function new = Newtons_Method(func,funcdiff1,tol,initval)

new = initval;
val = func(new);
if isa(funcdiff1,'function_handle')
    diffval = funcdiff1(new);
    fix = - (val)/(diffval);
else
    fix = -(val)/(funcdiff1);
end
new = new + fix ;

old = 0;
jdx = 0;
maxiter = 30;
while (abs(fix) > tol)&&(jdx<maxiter)
    val = func(new);
    if isa(funcdiff1,'function_handle')
        diffval = funcdiff1(new);
        fix = - (val)/(diffval);
    else
        fix = -(val)/(funcdiff1);
    end
    new = new + fix ;
    jdx = jdx+1;
end

if (jdx==maxiter) && (abs(new - old) > tol)
    error("Newton's method reached iteration limit \n current difference = %e, limit = %d [iter]",new - old,maxiter);
end


end

