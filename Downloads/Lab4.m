load("~/Downloads/Fence_data.mat");
s = size(artificial_data);
[l, m, n] = size(artificial_data);
V = zeros([l*m,n]);

V = reshape(artificial_data,[1024,69]);

const = 16;
W = 2*rand(1024,const);
H = 2*rand(const, 69);
iteration = 1000;

for i = 1:iteration
    W = (W .* ((V*H') + eps) ./ ((W*H*H') + eps));
    H = (H .* ((W'*V) + eps) ./ ((W'*W*H)) + eps);
end


W = reshape(W,[32,32,16]);

figure(1);

for r = 1:const
   subplot(4,4,r),imagesc(W(:,:,r)); 
end


V = reshape(V, [32,32,69])
for z = 1:const
    subplot(4,4,z),imagesc(V(:,:,z));
end
%imshow(H)
%output matrices
%W = reshape(W,[32,32,16]);
%for j = 1:32
 %   imshow(W(32,j,1:16))
%end


