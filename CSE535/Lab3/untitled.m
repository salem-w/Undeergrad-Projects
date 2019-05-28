A = [2 -3 2 1 4; 1 2 -4 -1 1; -2 4 1 1 3; 3 1 1 -2 -2; 2 6 1 -4 -2];
B = [26 -5 28 -10 -9];
%a = [a,b']
[m,n]=size(A);
for r = 1:n
    for i = 1:n
        if(i>r)
            t = A(i,r);
            A(i,:) = A(i,:)-A(r,:)*A(i,r)/A(r,r);
            B(i) = B(i)-B(r)*t/A(r,r);
        end
    end
end
A
B
%back-substitution
x = zeros(n,1);
%x = x';
for j = 1:n
    if(A(j,j) == 0)
        break;
    end
   x(j) = B(j)/A(j,j);
   for i = 1:n
       b(i) = b(i) - A(i,j)*x(j);
   end
end
x