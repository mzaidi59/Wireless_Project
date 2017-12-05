A=imread('oldhouse.pgm');
d=size(A,1);
for ii = 0:255
    dtb(ii+1,:) = double(de2bi(ii,8));
end
s = [-1,-1;-1,1;1,-1;1,1];
c=(s+1)/2;
C = [1,0,0,1,1,1,0,0];
dim = zeros(1,8);
Nt=2;
Nr=2;
SNR=10;

for x = 1:2:7
    X = C(x:x+1);
    X = 2*X-1;
    H = 1/sqrt(2*2)*[randn(2,2) + 1i*randn(2,2)];
    N = 1/sqrt(2)*[randn(1,2) + 1i*randn(1,2)];
    Y = sqrt(SNR)*X*H+N;
    temp = norm(Y-sqrt(SNR)*s*H);
    [a,b] = min(temp);
    dim(x:x+1) = c(b);
end
