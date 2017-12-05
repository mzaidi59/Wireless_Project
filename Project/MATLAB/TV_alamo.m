    A=imread('oldhouse.pgm');
    d=size(A,1);
    im(1:d,1:d) = 0;
    be= [0:0.0005:0.05];
    SNR=20;
    for ii = 0:255
        dtb(ii+1,:) = double(de2bi(ii,8));
    end
    np=256;% number of possible values a signal takes
    nb=log(np)/log(2); %no of bits being used to reprensent a signal value in binary
    pam=zeros(np,np);%path metric
    sm(1:np,1:d) = 0;% state metric
    ae(1:np,1:d) = 0; %accumlated error
    par(1:np,1:d)= 0; % parents of the elements of a trellis
    for xy=1:length(be);
        for i=1:np
            for j=1:np
                pam(j,i) = be(xy)*abs(i-j);%storing the path metric
            end
        end
        for ii=1:d%depicts that viterbi for iith row is taking place
%             ii
            for it=1:d %depicting the ith column in viterbi trellis
                %viterbi on ith row
                B = A(ii,it);
                C = 2*dtb(B+1,:)-1; %+-1 change
                n = 1/sqrt(2)*[randn(1,nb) + 1i*randn(1,nb)];
                h1 = 1/sqrt(2)*[randn(1,nb) + 1i*randn(1,nb)];
                y1 = h.*C + 10^(-SNR/20)*n;
                h2 = 1/sqrt(2)*[randn(1,nb) + 1i*randn(1,nb)];
                y2 = h.*C + 10^(-SNR/20)*n;
                y = (y1+y2)/2;
                for k=0:np-1
                    x=2*dtb(k+1,:)-1;
                    ul=0;
                    if(ii==1)%causal decoded neighbour contribution
                        ul=0;
                        mul=1;
                    elseif(it==1)
                        ul = ul+ abs(k-im(ii-1,it))+abs(k-im(ii-1,it+1));
                        mul=2;
                    elseif (it==d)
                        ul = ul+ abs(k-im(ii-1,it-1))+abs(k-im(ii-1,it));
                        mul=2;
                    else
                        ul = ul + abs(k-im(ii-1,it))+abs(k-im(ii-1,it-1))+abs(k-im(ii-1,it+1));
                        mul = 3;
                    end
                    sm(k+1,it) = norm(y-h.*x)^2 + be(xy)*ul/mul;
                    if it == 1
                        ae(k+1,it) = sm(k+1,it);
                    else
                        ta = ae(:,it-1)+ pam(:,k+1);
                        [m,index] = min(ta);
                        ae(k+1,it) = sm(k+1,it) + m;
                        par(k+1,it) = index;
                    end
                end
            end
            [val,key] = min(ae(:,d));
            im(ii, d) = key-1;
            for (t= d-1:-1:1)
                key = par(key,t+1);
                im(ii,t) = key-1;
            end
        end
        err(xy) = immse(uint8(im),A);
        psn(xy) = psnr(uint8(im),A);
    end
        im = uint8(im);
        imshow(im);



