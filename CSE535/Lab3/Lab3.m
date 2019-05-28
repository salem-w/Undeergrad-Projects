a = [2 -3 2 1 4; 1 2 -4 -1 1; -2 4 1 1 3; 3 1 1 -2 -2; 2 6 1 -4 -2];
b = [26 -5 28 -10 -9];
%a = [a,b']
[m,n]=size(a);
for j=1:m-1
    for z=2:m
        if a(j,j)==0
            t=a(j,:);a(j,:)=a(z,:);
            a(z,:)=t;
        end
    end
    for i=j+1:m
        a(i,:)=a(i,:)-a(j,:)*(a(i,j)/a(j,j));
    end
end
x=zeros(1,m);
for s=m:-1:1
    c=0;
    for k=2:m
        c=c+a(s,k)*x(k);
    end
    x(s)=(a(s,n)-c)/a(s,s);
end
disp('Gauss elimination method:');
a
x'