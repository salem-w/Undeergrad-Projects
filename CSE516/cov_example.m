x = [2.5 0.5 2.2 1.9 3.1 2.3 2 1 1.4 1.1];
y = [2.4 0.7 2.9 2.2 3.0 2.7 1.6 1.1 1.6 0.9];
mean_x = mean(x);
mean_y = mean(y);
x_adj = [];
y_adj = [];
for i = 1:numel(x)
    element = x(i);
    element_y = y(i);
    x_adj(i) = element - mean_x;
    y_adj(i) = element_y - mean_y;
end
cov_mat = cov(x_adj, y_adj);%covariance calculation, pretty accurate
[A, B] = eig(cov_mat);
FinalData_x = cross(A',x_adj);%not same size, won work
FinalData_y = cross(A', y_adj);