%currently not generalised over the constellation being used, only for
%BPSK. use e^(k*2pi)
A=imread('oldhouse.pgm');
d=size(A,1);
B=0.000001;%beta
tv = zeros(4,1);
for ii = 0:255
    dtb(ii+1,:) = double(de2bi(ii,8));
end
im = zeros(256,256);
s=2;
% C=[1 0 0 1 1 0 1 1 0 0 0 0 0 1 1 1 1 0 1 1 0 1 1 0 1 1 0 1 1 1 1 1 0 1 0 1 1 0 1 1 0 1 1 0 1 1 1 1 0 1 0 1 1 0 1 1 0 1 1 0];
SNR = [10];
ps = zeros(1,length(SNR));
for xx=1:length(SNR);
    for xz = 1:256
        for xy= 1:256
            C(1:8) = dtb(A(xz,xy)+1,:);
            Nt=2;
            Nr=2;
            %         SNR=20;
            s=2;
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
                    w(x) =w(x+nbit);
                end
                for x=1:nbit
                    w((Nt-1)*nbit+x) = C(nbit*(ii-1)+x);
                end
                prod = w * G;
                X(ii,:) = prod;
            end
            H(1:Nt,1:Nr) = 1/sqrt(2*Nt)*[randn(Nt,Nr) + 1i*randn(Nt,Nr)];
            N= 1/sqrt(2)*[randn(n,Nr) + 1i*randn(n,Nr)];
            % H(1:Nt,1:Nr) = 1/Nt;
            % N(1:n,1:Nr) = 0;
            X=2*X-1;
            Y = sqrt(SNR(xx))*X*H+N;
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
            aem(1:2^(nbit*Nt), 1:n) = 100;
            aemt(1:2^(nbit*Nt))=0;
            imt = [0;0;0;0];
            for jj=1:2^(nbit*Nt)
                aem(jj,1) = norm(Y(1,:) - sqrt(SNR(xx))*(2*sr(jj,:)-1)*H );
            end
            pindex = zeros(1,2^nbit);
            parent = zeros(2^(nbit*Nt),n);
            temp = zeros(1,Nt);
            for ii= 2:n
                for jj=1:2^(nbit*Nt)
                    temp = sr(jj,:);
                    for x=Nt : -1 :2
                        temp(x) = temp(x-1);
                    end
                    for x=1:2^nbit
                        temp(1) = x-1;
                        pindex(x) = temp*[s;1]+1;
                        tem = aem(pindex(x),ii-1)+norm(Y(ii,:) - sqrt(SNR(xx))*(2*sr(jj,:)-1)*H );
                        if aem(jj,ii) > tem
                            aem(jj,ii) = tem;
                            parent(jj,ii) = pindex(x);
                        end
                    end
                end
            end
            index = zeros(1,n);
            aemt = sort(aem(:,n));
            femt = sort(aem(:,n));
            for kk=1:length(aemt)
                index(1,n) = find(aem(:,n) == aemt(kk,1));
                for ii= n:-1:2
                    index(ii-1) = parent(index(ii),ii);
                end
                answ = zeros(size(index,2),size(sr,2));
                for ii = 1:size(index,2)
                    answ(ii,:) = sr(index(1,ii),:);
                end
                imt(kk,1) = bi2de(transpose(answ(:,2)));
                if xz==1 || xy==1
                    tv(kk)=0;
                elseif xz==1 && xy~=1
                    tv(kk) = tv(kk) + B*(abs(imt(kk,1)-im(xz,xy-1)));
                elseif xy==1 && xz~=1
                    tv(kk) = tv(kk) + B*(abs(imt(kk,1)-im(xz-1,xy))+abs(imt(kk,1)-im(xz-1,xy+1)))/2;
                elseif xy==256
                    tv(kk) = tv(kk) +B*(abs(imt(kk,1)-im(xz,xy-1))+ abs(imt(kk,1)-im(xz-1,xy-1))+ abs(imt(kk,1)-im(xz-1,xy))+abs(imt(kk,1)))/3;
                else
                    tv(kk) = tv(kk) + B*(abs(imt(kk,1)-im(xz,xy-1))+ abs(imt(kk,1)-im(xz-1,xy-1))+ abs(imt(kk,1)-im(xz-1,xy))+abs(imt(kk,1)+im(xz-1,xy+1)))/4;
                end
                femt = aemt + tv;
                [t,indi] = min(femt);
            end
            im(xz,xy) = imt(indi,1);
        end
    end
    ps(xx) = psnr(im,A);
end
im = uint8(im);