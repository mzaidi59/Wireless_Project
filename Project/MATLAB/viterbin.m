function [mindist,ind,survpath,dist,srx,data] = viterbin (distance,v,M,G,row,im,B)
mindist=1;
ind=2;
survpath=3;
numstate = 2^v;
[brs kol]=size (distance);
dist(1:numstate, 1:kol) = Inf;
[trellis1,trellis2,statego]=gen2trellis(G,M);
state= 0;
m =log2 (M);
num_sym = 8/m;
for a = 1:kol
    if a == 1
        for jj =1:M
            nstate = statego(1,jj);
            dist(nstate+1,1) = distance(jj,1);
        end
    else
        for ii = 1:numstate
            if dist(ii,a-1) ~=Inf;
                for jj=1:M
                    temdis = dist(ii,a-1) + distance((ii-1)*M + jj,a);
                    nstate = statego(ii, jj);%next state
                    if dist(nstate+1,a) > temdis
                        dist(nstate+1,a) = temdis;
                        parent(nstate+1,a) = ii-1;
                    end
                end
            end
        end
    end
    if mod(a,num_sym)==0
        for ii = 1:numstate
            cstate= ii-1;
            if dist(ii,a)~=Inf
                dist(ii,a) = dist(ii,a) + B * tvcom(im,row,parent,a,ii,statego);
            end
        end
    end
end
[val,ii] = min(dist(:,kol));
aa = kol;
for jj =1:kol
    srx(1,kol+1-jj) = trellis1(parent(ii,aa)+1,find(statego(parent(ii,aa)+1,:)==ii-1));
    srx(2,kol+1-jj) = trellis2(parent(ii,aa)+1,find(statego(parent(ii,aa)+1,:)==ii-1));
    data(kol*m+1-m*jj:kol*m+m-m*jj) = fliplr(de2bi((find(statego(parent(ii,aa)+1,:)==ii-1))-1,m));
    ii = parent(ii,aa)+1;
    aa=aa-1;
end