function imse = immse(X, Y)
if isempty(X)
    imse = [];
    return;
end
X = double(X);
Y = double(Y);

imse = (norm(X(:)-Y(:),2).^2)/numel(X);
imse
end

