clc;
close all;
clear all;
tic;
A=imread('lena_gray_32.pgm');
d=2.32
% A=imread('lena_gray_256.pgm');
% d=2.256
% A=imread('oldhouse.pgm');
% d=1.256
iteration = 1000; % jum
[R C] = size(A);
%  beta = [0.00,0.03,0.035];%2.256.1
% beta = [0,0.009,0.010,0.015,0.016];%1.32.2
beta = [0.01];
Ntx=2; Nrx=2;
SNR_max = 15;
snr=[5,6,7,8,10,11,12,13,14,15,16,17,18,19,20];% in dB
if Nrx == 1
    IM = 1; % identity matrix
elseif Nrx == 2
    IM = [1 0; 0 1]; % identity matrix
end
im = zeros(size(A,1),size(A,2));
for ii = 0:255
    dtb(ii+1,:) = double(de2bi(ii,8));
end
% --- Parameter STTC ---
%G=[0 2;0 1;2 0;1 0];
%G=[2 2;0 1;2 0;1 0;2 2];
 G = [1 2;2 0;2 1;0 2;0 2;2 0];
M = 4; % M-PSK = QPSK
% ----------------------
m =log2 (M);
num_sym = 8/m;
bit_error = 0;% zeros(1,length(snr));
total_bit_error = zeros(1,C);
BER = zeros(1,length(snr));
simbol_error = zeros(1,length(snr));
pair_err1 = zeros(Ntx,C*num_sym);
pair_err2 =  zeros(1,C*num_sym);
pair_err3 =  zeros(1,length(snr));
% ****************************** Transmitter ******************************
% ==== Data ====
% data=randint(1,50,2);
for bb = 1:length(beta)
    for oye = 1:length(snr)
        for jum=1:iteration
            for xz=1:R
                xz
                for xy=1:C
                    data(8*xy-7:8*xy) = dtb(A(xz,xy)+1,:);
                end
                % ==== Encoder STTC ====
                [s,data_mod,v] = encsttc(G,data,M);%data mod gives the series of bits to be transmitted
                input_kanal = data_mod;
                H=[randn(Nrx,Ntx,C) + 1i*randn(Nrx,Ntx,C)]; % MIMO channel
                for i=1:C
                    transmitted_signal(:,num_sym*(i-1)+1:num_sym*i)=H(:,:,i)*input_kanal(:,num_sym*(i-1)+1:num_sym*i);%/sqrt(2);
                end
                %  Noise Addition
                received_signal=awgn(transmitted_signal,snr(oye),'measured');
                map = symbolref(G,M);
                allsum = ML(received_signal,map,H,Nrx);
                if(snr(oye)>15)
                    beta(bb) = 0.005;
                end
                [mindist,ind,survpath,dist,srx,data_topi] = viterbin(allsum,v,M,G,xz,im,beta(bb));
                for ii=1:C
                    cc = data_topi(8*ii-7:8*ii);
                    im(xz,ii) = bi2de(cc);
                end
                % ==== Performance Evaluation ====
                bit_error = bit_error + sum(data~=data_topi); % BER
                simbol_error(1,oye) = simbol_error(1,oye)+ sum(sum(s~=srx)); % SER
                pair_err1 = sum(s~=srx);%any one of the antennas is read erroneously
                for q = 1:length(pair_err1)
                    if pair_err1(q) ~= 0% non zero means error
                        pair_err2(q) = 1;
                    else
                        pair_err2(q) = 0;
                    end
                end
                pair_err3(1,oye) = sum(pair_err2); % PEP
                %                 Eb_No=snr(oye)-3;
                %                 EbNo=10^(Eb_No/10);
                %                 cap(1,oye)=log2(det(IM + (EbNo/Ntx)*H*H')); % MIMO channel capacity
                %                 fprintf('Looping = %1d, SNR = %1d, BitError = %1d, SymbolError = %1d, PairError = %1d\n',...
                %                     jum,snr(oye),bit_error(oye),simbol_error(oye),pair_err3(oye));
                %                 if snr(oye) == max(snr)
                %                     display('*****************************');
                %                 end
                
                %     for yipi=1:length(bit_error)
                %         if bit_error(yipi)==0
                %             fer(yipi)=0;
                %         else
                %             fer(yipi)=1;
                %         end
                %     end
                %     total_fer(jum,:)=fer;
                total_bit_error(xz) = total_bit_error(xz) + bit_error;
                bit_error = 0;
                %     total_simbol_error(jum,:) = simbol_error;
                %     total_pep(jum,:) = pair_err3;
                %     total_cap(jum,:) = cap;
                
            end
            % SER = sum(total_simbol_error)/((size(s,1))*(size(s,2))*iteration);
            % PEP = sum(total_pep)/(size(s,2)*iteration);
            % FER = sum(total_fer)/iteration;
            % CAP = abs(sum(total_cap)/iteration);
            % SIG = singular;
            %
            % figure; % BER vs SNR in logaritmic value
            % semilogy(snr,BER,'b:*'); hold on
            % semilogy(snr,SER,'r:^'); hold on
            % semilogy(snr,PEP,'b-*'); hold on
            % semilogy(snr,FER,'g-o');grid
            % legend('BER','SER','PEP','FER')
            %
            
            %
            % figure; % MIMO channel capacity
            % plot(snr,CAP,'r-*');grid
            %
            % figure; % singular value
            % [y,x]=hist(reshape(SIG,[1,min(Ntx,Nrx)*iteration]),100);
            % plot(x,y/iteration); grid
            im = uint8(im);
            beta(bb)
            pp(bb) = psnr(A,im);
        end
        BER(oye) = sum(total_bit_error)/(length(data)*xz*iteration);
        total_bit_error = zeros(1,C);
    end
end
figure; % BER vs SNR in linear value
plot(snr,BER,'b:*'); hold on
%         plot(snr,SER,'r:^'); hold on
%         plot(snr,PEP,'b-*'); hold on
%         plot(snr,FER,'g-o'); grid
%         legend('BER','SER','PEP','FER')
toc
waktu_jam=toc/3600;
iteration
bet = 0.01005
state =16
% save STTC_1x2 BER SER PEP CAP SIG snr