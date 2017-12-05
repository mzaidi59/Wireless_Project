%currently not generalised over the constellation being used, only for
%BPSK. use e^(k*2pi)
A=imread("lena_gray_32.pgm");
sz=size(A,1);
for ii = 0:255
    dtb(ii+1,:) = double(de2bi(ii,8));
end
% B=[0,0.0000005,0.000001,0.000005,0.00001,0.00005,0.0001,0.0005,0.001,0.005,0.01,0.05,0.1,0.5,1];
% B=[0.0001,0.003,0.005,0.007,0.01];
B=[0,0.01];
im = zeros(sz,sz);
s=2;
tvm=0;%tv metric
tem=zeros(1,length(B));
% C=[1 0 0 1 1 0 1 1 0 0 0 0 0 1 1 1 1 0 1 1 0 1 1 0 1 1 0 1 1 1 1 1 0 1 0 1 1 0 1 1 0 1 1 0 1 1 1 1 0 1 0 1 1 0 1 1 0 1 1 0];
C=zeros(1,sz*8);
SNR = [5];
ps = zeros(length(B),length(SNR));
for zyz=1:length(B)
    for xx=1:length(SNR);
        for xz = 1:sz
            for xy=1:sz
                C(8*xy-7:8*xy) = dtb(A(xz,xy)+1,:);
            end
            Nt=2;
            Nr=2;
            s=2;
            H = zeros(Nt,Nr,sz);
            nbit=log(s)/log(2);
            n = length(C)/nbit;
            w = zeros(1,nbit*Nt);
            G = zeros(Nt*nbit,Nt);
            temp = s;
            for ii=1:nbit
                G(ii,1) = floor(temp/2);
                G(ii+nbit,2) = floor(temp/2);
                temp = floor(temp/2);
            end
            X= zeros(n,Nt);
            for ii=1:n
                for x= 1: nbit*Nt-nbit
                    w(x) = w(x+nbit);
                end
                for x=1:nbit
                    w((Nt-1)*nbit+x) = C(nbit*(ii-1)+x);
                end
                prod = w * G;
                X(ii,:) = prod;
                if ceil(ii/8)~=ceil((ii-1)/8)
                    H(:,:,ceil(ii/8)) = 1/sqrt(2*Nt)*[randn(Nt,Nr) + 1i*randn(Nt,Nr)];
                    %                     N = 1/sqrt(2)*[randn(1,Nr) + 1i*randn(1,Nr)];
                end
                X(ii,:) =2*X(ii,:)-1;
                transmitted_signal = sqrt(SNR(xx))*X(ii,:)*H(:,:,ceil(ii/8));
                Y(ii,:) = awgn(transmitted_signal,SNR(xx),'measured');
            end
            d = zeros(1, 2^(nbit*Nt));
            for x=1:2^(nbit*Nt);
                d(x) = x-1;
            end
            sr=double(uint8(dec2base(d,2^nbit))-48);
            for x = 1:2^(nbit*Nt)
                for y = 1:2
                    if sr(x,y)>10
                        sr(x,y) = sr(x,y)-7;
                    end
                end
            end
            aem(1:2^(nbit*Nt), 1:n) = Inf;
            for jj=1:2^(nbit*Nt)%for the first column of the trellis
                aem(jj,1) = norm(Y(1,:) - sqrt(SNR(xx))*(2*sr(jj,:)-1)*H(:,:,ceil(1/8)));
            end
            pindex = zeros(1,2^nbit);
            parent = zeros(2^(nbit*Nt),n);
            temp = zeros(1,Nt);
            for ii= 2:n
                for jj=1:2^(nbit*Nt)%2^size of w is possible no of states
                    temp = sr(jj,:);%the state corresponding to the current trellis state
                    for x=Nt : -1 :2
                        temp(x) = temp(x-1);%shifitng to find previous possible states
                    end
                    for x=1:2^nbit
                        temp(1) = x-1;%keeping all possible states at the antenna 1 position
                        pindex(x) = temp*[s;1]+1;
                        %                     if pindex<1
                        %                         temp
                        %                     end
                        tem(1,zyz) = aem(pindex(x),ii-1)+norm(Y(ii,:) - sqrt(SNR(xx))*(2*sr(jj,:)-1)*H(:,:,ceil(ii/8)));
                        tvm = tvm +B(zyz)*tvc(im,ii,jj,sr,xz,sz);
                        if mod(ii,8)==0
                            tem(1,zyz) = tem(1,zyz) + abs(tvm);
                            tvm = 0;
                        end
                        if aem(jj,ii) > tem(1,zyz)
                            aem(jj,ii) = tem(1,zyz);
                            parent(jj,ii) = pindex(x);
                        end
                    end
                end
            end
            index = zeros(1,n);
            [t, index(n)] = min(aem(:,n));
            for ii= n:-1:2
                index(ii-1) = parent(index(ii),ii);
            end
            answ = zeros(size(index,2),size(sr,2));
            for ii = 1:size(index,2)
                answ(ii,:) = sr(index(1,ii),:);
            end
            for ii=1:sz
                c = answ(8*ii-7:8*ii,2);
                im(xz,ii) = bi2de(transpose(c));
            end
            xz
        end
        ps(zyz,xx) = psnr(im,A);
    end
end