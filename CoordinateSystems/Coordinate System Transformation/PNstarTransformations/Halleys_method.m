function new = Halleys_method(func,funcdiff1,funcdiff2,tol,initval)

new = initval;
val = func(new);
diffval = funcdiff1(new);
diff2val = funcdiff2(new);
fix = -2*(val*diffval)/(2*diffval^2-val*diff2val);
new = new+fix;

jdx = 0;
maxiter = 10000;
while (abs(fix) > tol)&&(jdx<maxiter)
    val = func(new);
    diffval = funcdiff1(new);
    diff2val = funcdiff2(new);
    fix = -2*(val*diffval)/(2*diffval^2-val*diff2val);
    new = new + fix;
    jdx = jdx+1;
end

if (jdx==maxiter) && (abs(fix) > tol)
    error("Halley's method reached iteration limit \n current difference = %e, limit = %d [iter]",abs(fix),maxiter);
end


end

