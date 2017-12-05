function [ tvc ] = tvcom(im,row,parent,a,ii,statego)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
M = size(statego,2);
m =log2 (M);
num_sym = 8/m;
col = ceil(a/num_sym);
val = undecn(parent,ii,statego,a);
p=ii;
aa=a;
if col~=1
    for zz=1:num_sym
        p=parent(p,aa)+1;
        aa = aa-1;
    end
    vaenc = undecn(parent,p,statego,aa);
end
if row==1 && col==1
    tvc=0;
elseif row ==1
    tvc = abs(val-vaenc);
elseif col == 1
    tvc = (abs(val-im(row-1,col))+abs(val-im(row-1,col+1)))/2;
elseif col== size(im,2)
    tvc = (abs(val-im(row-1,col))+abs(val-im(row-1,col-1))+abs(val-vaenc))/3;
else
    tvc = (abs(val-im(row-1,col))+abs(val-im(row-1,col-1))+abs(val-im(row-1,col+1))+abs(val-vaenc))/4;
end

