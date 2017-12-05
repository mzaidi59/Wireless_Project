function dbs = psnr(X,Y)
dbs=1e5;
if X == Y
    error('Same Images')
end
X = double(X);
Y = double(Y);
imse = (norm(X(:)-Y(:),2).^2)/numel(X);
dbs = 20*log10(255/(sqrt(imse)));
disp(sprintf('PSNR = +%5.2f dB',dbs))
end
