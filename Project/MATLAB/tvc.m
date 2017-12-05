function [ val ] = tvc(im,ii,jj,sr,xz)
%UNTITLED3 Summary of this function goes here
%   element 1,2 & 3 in the row above
val=0;
col = ceil(ii/8);
bit = mod(ii,8);
if bit==0
    bit=8;
end
if xz ==1
    val=0;
elseif col==1
    im2 = de2bi(im(xz-1,col),8);
    im3 = de2bi(im(xz-1,col+1),8);
    val = val + (2^(bit-1)*(sr(jj,2)-im2(bit))+2^(bit-1)*(sr(jj,2)-im3(bit)))/2;
elseif col==256
    im1 = de2bi(im(xz-1,col-1),8);
    im2 = de2bi(im(xz-1,col),8);
    val = val + (2^(bit-1)*(sr(jj,2)-im1(bit))+2^(bit-1)*(sr(jj,2)-im2(bit)))/2;
else
    im1 = de2bi(im(xz-1,col-1),8);
    im2 = de2bi(im(xz-1,col),8);
    im3 = de2bi(im(xz-1,col+1),8);
    val = val + (2^(bit-1)*(sr(jj,2)-im1(bit))+2^(bit-1)*(sr(jj,2)-im2(bit))+2^(bit-1)*(sr(jj,2)-im3(bit)))/3;
end

