load("~/Downloads/Fence_data.mat");
s = size(artificial_data);
[l, m, n] = size(artificial_data);
A = zeros([l*m,n]);

A = reshape(artificial_data,[1024,69]);

const = 16;

W = rand(x,const)
H = rand(const, x)