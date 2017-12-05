function symbol = symbolref(G,M)

[trellis1,trellis2,statego]=gen2trellis(G,M);
[a b] = size (trellis1);
for l=0:a-1
    for j=1:b
        ref(l*M+j,1) = trellis1 (l+1,j);
        ref(l*M+j,2) = trellis2 (l+1,j);
    end
end
[n m]=size(ref);
ref;
symbol = [];
for a=1:n
    for b=1:m
        if ref(a,b)== 0
            symbol(a,b) = exp(1i*5*pi/M);;
        elseif ref(a,b)== 1
            symbol(a,b) = exp(1i*3*pi/M);
        elseif ref(a,b)== 2
            symbol(a,b) =  exp(1i*7*pi/M);
        elseif ref(a,b)== 3
            symbol(a,b) = exp(1i*1*pi/M);
        end;
    end;
end;