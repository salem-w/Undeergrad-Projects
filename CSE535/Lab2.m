abs_err = zeros(1,10);
rel_err = zeros(1,10);
for n = 1:10
    p = gamma(n+1);
    stirling = sqrt(2*pi*n)*(n/exp(1))^n;
    error = stirling - p;
    rel_err(1,n) = error;
    error = error/p;
    abs_err(1,n) = error;
end
abs_err
rel_err

