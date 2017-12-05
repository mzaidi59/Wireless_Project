function [bits] = getbits(x, n) 
% dec to bin

bits = zeros(1, n); 
ind  = 1; 
while (x~=0) 
    bits(ind) = mod(x,2); 
    x = floor(x/2); 
    ind = ind + 1; 
end 
bits = fliplr(bits); 