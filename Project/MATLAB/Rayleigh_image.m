A=imread('lena512.pgm');
B=de2bi(A);
C=B;
C=int8(C);
C=2*C-1;
%checked till here 
a=size(C);
N=a(1,1)*a(1,2);
%s=double(reshape(C,1,N));
w=[0 0 0];
s1 = zeros(N+2,1);
s2 = zeros(N+2,1);
for ii=1:N;
    w(3) =w(2);
    w(2) = w(1);
    w(1) = C(ii);
    %GP 111 and 101
    temp = xor(w(1),w(2));
    s1(ii)=xor(temp,w(3));
    s2(ii)=xor(w(1),w(3));
    
end
s1=squeeze(s1);
s2=squeeze(s2);
N1=size(s1,1);
N2=size(s2,1);    
n = 1/sqrt(2)*[randn(N1,1) + j*randn(N1,1)]; % white gaussian noise, 0dB variance 
h = 1/sqrt(2)*[randn(N1,1) + j*randn(N1,1)]; % Rayleigh channel
y1 = h.*s1 + 10^(-10/20)*n; 
y2 = h.*s2 + 10^(-10/20)*n; 
y1=double(real(y1)>0);
y2=double(real(y2)>0);
%yHat = y./h;  
%ipHat = real(yHat)>0;
%ipHat=int8(ipHat);
%f=reshape(ipHat,262144,8);
%im=bi2de(f);
%ima=reshape(im,512,512);

%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Viterbi from here
%     
% 
% %Concatenate two consecutive bits of recieved encoded sequence to 
% %make up a symbol
% input=[];
% for j=1:1:length(y1)
%    input=[ input (y1(j))* 2 + (y2(j))];
% end
% 
% %initializing all arrays
% op_table=[00 00 11; 01 11 00; 10 10 01; 11 01 10]; %OUTPUT array
% ns_table=[0 0 2; 1 0 2; 2 1 3; 3 1 3]; %NEXT STATE array
% transition_table=[0 1 1 55; 0 0 1 1; 55 0 55 1; 55 0 55 1];
%  
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                    A R R A Y S - U P D A T I N G  Part
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% st_hist(1:4, 1:size(y1))=55; %STATE HISTORY array
% y1=squeeze(y1);
% y2=squeeze(y2);
% Nx=size(y1);
% aem=zeros(4,Nx ); %ACCUMULATED ERROR METRIC (AEM) array
% ssq=zeros(1, Nx); %STATE SEQUENCE array
% 
% % input=rcvd;
% %input(1, :)=bin2dec(rcvd)
% %input=[0 3 3 0 1 2 1 3 3 2 0 0 3 0 3 2 3]    %INPUT vector  
% %rcvd=['00';'11';'11';'00';'01';'10';'01';'11';'11';'10';'00';'00';'11';'00';'11';'10'; '11']
% 
% lim=length(input); %number of clock cycles
% for (t=0:1:lim) %clock loop
% %     disp('------------------------------------------------------')
%     t; %display current clock instance
%     if(t==0)
%         st_hist(1,1)=0;        %start at state 00
%     else
%         temp_state=[];%vector to store possible states at an instant
%         temp_metric=[];%vector to store metrics of possible states  
%         temp_parent=[];%vector to store parent states of possible states 
%         
%         for (i=1:1:4) 
%             i; 
%             in=input(t);
%             if(st_hist(i, t)==55)  %if invalid state
%                 %do nothing
%             else    
%                 ns_a=ns_table(i, 2)+1;    %next possible state-1
%                 ns_b=ns_table(i, 3)+1;    %next possible state-2 
%         
%                 op_a=op_table(i, 2);      %next possible output-1
%                 op_b=op_table(i, 3);      %next possible output-2
%                 
%                 cs=i-1;                   %current state
%                 
%                 M_a=hamm_dist(in, op_a);  %branch metric for ns_a
%                 M_b=hamm_dist(in, op_b);  %branch metric for ns_b
%           
%                 indicator=0; %flag to indicate redundant states
%                 
%                 for k=1:1:length(temp_state) %check redundant next states
%                     %if next possible state-1 redundant
%                     if(temp_state(1,k)==ns_a) 
%                         indicator=1;
%                         %ADD-COMPARE-SELECT Operation
%                         %em_c: error metric of current state
%                         %em_r: error metric of redundant state
%                         em_c=M_a + aem(i,t);
%                         em_r=temp_metric(1,k) + aem(temp_parent(1, k)+1,t);                        
%                         if( em_c< em_r)%compare the two error metrics
%                             st_hist(ns_a,t+1)=cs;%select state with low AEM
%                             temp_metric(1,k)=M_a;
%                             temp_parent(1,k)=cs;
%                         end
%                     end
%                     %if next possible state-2 redundant
%                     if(temp_state(1,k)==ns_b)
%                         indicator=1;
%                         em_c=M_b + aem(i,t);
%                         em_r=temp_metric(1,k) + aem(temp_parent(1, k)+1,t);
%                         
%                         if( em_c < em_r)%compare the two error metrics
%                             st_hist(ns_b,t+1)=cs;%select state with low AEM
%                             temp_metric(1,k)=M_b;
%                             temp_parent(1,k)=cs;
%                         end 
%                     end 
%                 end     
%                 %if none of the 2 possible states are redundant
%                 if(indicator~=1)
%                     %update state history table
%                     st_hist(ns_a,t+1)=cs; 
%                     st_hist(ns_b,t+1)=cs;
%                     %update the temp vectors accordingly                   
%                     temp_parent=[temp_parent cs cs];
%                     temp_state=[temp_state ns_a ns_b];
%                     temp_metric=[temp_metric M_a, M_b];
%                 end
%                 %print the temp vectors
%                 temp_parent;
%                 temp_state;
%                 temp_metric;  
%             end   
%         end
%         %update the AEMs (accumulative error metrics) for all states for
%         %current instant 't'
%         for h=1:1:length(temp_state)
%             xx1=temp_state(1, h);
%             xx2=temp_parent(1, h)+1;
%             aem(xx1, t+1)=temp_metric(1, h) + aem(xx2, t);
%         end 
%     end
% end %end of clock loop
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                       T R A C E - B A C K   Part
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for(t=0:1:lim)
%     slm=min(aem(:, t+1));
%     slm_loc=find( aem(:, t+1)==slm );
%     sseq(t+1)=slm_loc(1)-1;
% end
% 
% dec_op=[];
% for p=1:1:length(sseq)-1
%     p;
%     dec_op=[dec_op, transition_table((sseq(p)+1), (sseq(p+1)+1))];
% end
% %ipHat=int8(ipHat);
% %f=reshape(ipHat,262144,8);
% %im=bi2de(f);
% %ima=reshape(im,512,512);
% 

