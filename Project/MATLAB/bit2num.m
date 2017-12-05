function [y] = bit2num(x) 

y = 0; mul = 1; 
for i=(length(x):-1:1) 
    y = y + mul*x(i); 
    mul = mul*2; 
end 