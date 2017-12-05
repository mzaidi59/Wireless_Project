function [s,data_mod,v] = encsttc(G,input,M)

[a b]= size(input);
% v1 = length(g1)-1;
% v2 = length(g2)-1;
m =log2 (M);     
v = size(G,1)-m; % memory degree

% serial to paralel
n_kol = b/m;
for index=0:n_kol-1
    c(:,index+1) = input(1,(m * index)+1:m*(index+1));
end
temp = zeros (1,m+v);
for k=0:n_kol-1 % time
    % initialzation
    for in=0:v-1
        temp(v+m-in)=temp(v-in);
    end
    temp(1:m)=c(:,k+1);%new entries after shifting stored at the start of temp
    shat(:,k+1) = temp*G;
    temp;
end
s = mod(shat,M);
[n m]=size(s);
data_mod=[];
% Mapper QPSK from symbol STTC
for a=1:n
    for b=1:m
        if s(a,b)==[0]
            data_mod(a,b) = exp(1i*5*pi/M);
        elseif s(a,b)==[1]
            data_mod(a,b) = exp(1i*3*pi/M);
        elseif s(a,b)==[2]
            data_mod(a,b) = exp(1i*7*pi/M);
        elseif s(a,b)==[3]
            data_mod(a,b) = exp(1i*1*pi/M);
        end;
    end;
end;