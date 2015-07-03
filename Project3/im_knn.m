function I_knn = im_knn(X, Y, k)
    X_size = size(X, 1);
    Y_size = size(Y, 1);
    d_m = zeros(Y_size, X_size);
    for i = 1 : X_size
        d_m(:, i) = sum(bsxfun(@minus, Y, X(i, :)) .^ 2, 2);
    end

    [~, I] = sort(d_m);
    I_knn = I(1 : k, :)';
end