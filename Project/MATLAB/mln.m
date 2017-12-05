A=imread('oldhouse.pgm');
d=size(A,1);
for ii = 0:255
    dtb(ii+1,:) = double(de2bi(ii,8));
end
s = [-1,-1;-1,1;1,-1;1,1];
c=(s+1)/2;
SNR = [20];
ps = zeros(1,length(SNR));
for xx=1:length(SNR);
    for xz = 1:256
        for xy= 1:256
            C(1:8) = dtb(A(xz,xy)+1,:);
            dim = zeros(1,8);
            Nt=2;
            Nr=2;
            temp = zeros(1,4);
            for x = 1:2:7
                X = C(x:x+1);
                X = 2*X-1;
                H = 1/sqrt(2*2)*[randn(2,2) + 1i*randn(2,2)];
                N = 1/sqrt(2)*[randn(1,2) + 1i*randn(1,2)];
                Y = sqrt(SNR(xx))*X*H+N;
                for k=1:4
                    temp(1,k) = norm(Y-sqrt(SNR(xx))*s(k,:)*H);
                end
                [a,b] = min(temp);
                dim(x:x+1) = c(b,:);
            end
            im(xz,xy) = bi2de(dim);
        end
    end
    ps(xx) = psnr(im,A);
end