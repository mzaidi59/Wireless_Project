function [ val ] = undecn( parent,ii,statego,a )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    aa=a;
    M = size(statego,2);
    m =log2 (M);     
    num_sym = 8/m;
for jj =1:num_sym
    dat(9-m*jj:8+m-m*jj) = fliplr(de2bi((find(statego(parent(ii,aa)+1,:)==ii-1))-1,m));
    ii = parent(ii,aa)+1;
    aa=aa-1;
end
val = bi2de(dat);
end

