function [ tvc ] = tvco(im,row,dat,a)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
col = ceil(a/4);
tvc = 0;
data = dat(2*a-7:2*a);
if col~=1
    denc = dat(2*(a-1)-7:2*(a-1));
    vaenc = bi2de(denc);
end
val = bi2de(data);
if row ==1
    tvc =0;
elseif col == 1
    tvc = tvc + (abs(val-im(row-1,col))+abs(val-im(row-1,col+1)))/2;
elseif col==256
    tvc = tvc + (abs(val-im(row-1,col))+abs(val-im(row-1,col-1))+abs(val-vaenc))/3;
else
    tvc = tvc + (abs(val-im(row-1,col))+abs(val-im(row-1,col-1))+abs(val-im(row-1,col+1))+abs(val-vaenc))/4;
end

