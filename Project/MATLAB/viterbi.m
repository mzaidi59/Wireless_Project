function [mindist,ind,survpath,dist,srx,data] = viterbi (distance,v,M,G,row,im,B)
numstate = 2^v;
dist = [];
[brs kol]=size (distance);
[trellis1,trellis2,statego]=gen2trellis(G,M);
state= 0;
for a = 1:kol
    if a == 1
        dist(:,a) = distance(1:numstate,a);
    else
        disthat = [];
        for b=0:M-1
            for bb=1:numstate
                if bb < 5
                    disthat(bb,b+1) = dist(b*(v-1)+1,a-1)+ distance(b*numstate+bb,a);
                else
                    disthat(bb,b+1) = dist(b*(v-1)+2,a-1)+ distance(b*numstate+bb,a);
                end
            end
        end
        disthat;
        for bb=1:numstate
            dist(bb,a) = min (disthat(bb,:));
        end
        
        %         if mod(a,4) == 0
        %             for jj = 1:4
        %
        %             reshape((uint8(tem)-48)',1,8);
        %             dist(bb,a) = dist(bb,a) + B * tvc
        %         end
    end
    % end
    % state= 0;
    % for a = 1:kol
    demap = [0 0;0 1;1 0;1 1]';
    if mod(a,4)==0
        for ii = 1:4
            cstate= ii-1;
            dd =find (cstate == statego(ind(1,a-1),:));
            data(1,2*(a-1)+1:2*(a-1)+2)= demap(:,dd)';
            dist(ii,a) = dist(ii,a) + B * tvco(im,row,data,a);
        end
    end
    p = statego(state+1,1)+1;%min_max check
    q = statego(state+1,4)+1;
    [mindist(:,a),ind(:,a)] = min (dist(p:q,a));
    if p ~= 1
        ind(:,a)=ind(:,a)+4;
    end
    state = ind(:,a)-1;
    
    % end
    survpath = ind -1;
    %inputs corresponding to states
    % for a = 1:kol
    if a == 1
        srx(1,a) = trellis1(1,ind(1,a));
        srx(2,a) = trellis2(1,ind(1,a));
        data(1,2*(a-1)+1:2*(a-1)+2)= demap(:,ind(1,a))';
    else
        dd =find (survpath(1,a) == statego(ind(1,a-1),:));
        srx(1,a) = trellis1(ind(1,a-1),dd);
        srx(2,a) = trellis2(ind(1,a-1),dd);
        data(1,2*(a-1)+1:2*(a-1)+2)= demap(:,dd)';
    end
%     if mod(a,4) == 0
%         bi2de(data( 2*a-7:2*a))
%     end
end