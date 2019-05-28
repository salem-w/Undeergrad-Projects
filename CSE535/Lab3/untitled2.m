A = [2 -3 2 1 4; 1 2 -4 -1 1; -2 4 1 1 3; 3 1 1 -2 -2; 2 6 1 -4 -2];
B = [26 -5 28 -10 -9];

%opts.UT = true; opts.TRANSA = true;
x1 = linsolve(A, B')
B = B';

mldivide(A,B)