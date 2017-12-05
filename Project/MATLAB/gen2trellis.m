function [trellis1,trellis2,statego]=gen2trellis(G,M)
% function to change generator code to trellis
% trellis1 = trellis antenna 1
% trellis2 = trellis antenna 2
% statego  = state moving
% v1 = length(g1)-1;
% v2 = length(g2)-1;
m =log2 (M);
v = size(G,1)-m;       
jumlahstate = 2^v;
state = 0:jumlahstate-1;
for a=1:jumlahstate
    for b=1:M
        input = [getbits(state(1,b),m),getbits(state (1,a),v)];%input at start then state bits as in encsttc
        shat = input * G; 
        s = mod(shat,M);
        trellis1(a,b) = s(1,1);
        trellis2(a,b) = s(1,2);
        statego(a,b) = bit2num(input(1,1:v));%new state corresponding to new input
    end
end