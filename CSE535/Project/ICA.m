[y, Fs1] = audioread("you-are-acting-so-weird.wav");
[z, Fs2] = audioread("youre-on-the-right-track.wav");
%sound(y,Fs1); % Plays 100 Hz
%sound(z,Fs2); % 
%sound(y+z, Fs1);
lenY = size(y,1);
lenZ = size(z,1);
len = max(lenY,lenZ);
w = zeros(len, size(y,2));
w(1:lenY,:) = y;
w(1:lenZ,:) = w(1:lenZ,:) + z;
maxVal = max(abs(w(:)));
w = w / maxVal;
%sound(w,Fs1);
subplot(3,2,1),plot(y);
subplot(3,2,2),plot(z);
subplot(3,1,3),plot(w);


a = rand(2);
x = w * a;
pca_ica(x);

subplot(3,2,3),plot(b);


function [b,c] = pca_ica(x)
    n = size(x,1);
    
    [E,D] = eig(cov(x'));
    v = E * D^(-0.5) * E' * x;
    r = repmat(sqrt(sum(v.^2)),n,1).*v;
    [EE,DD] =eig(cov(r'));
    b = EE' * v;
    c = EE';
end





