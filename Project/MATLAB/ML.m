function dist = ML(symrec,symref,H,numrx);

% maximum likelyhood function
%     dist = ML
%     symrec = received symbol
%     symref = reference symbol
%     kanal = channel response


for a=1:length(symrec)
    for p=1:size(symref,1)
        for b=0:numrx-1
            disthat(1,b+1)=norm((H(b+1,:,ceil(a/4))*symref(p,:).' - symrec(b+1,a)),'fro');
        end
        dist(p,a) = sum(disthat)/numrx;
    end
end