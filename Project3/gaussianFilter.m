function [ gfilter, fiveSigma ] = gaussianFilter(sigma )
%GAUSSIANFILTER return a gaussian mask

fiveSigma = round(5*sigma);
[X, Y] = meshgrid(-fiveSigma:fiveSigma, -fiveSigma:fiveSigma);
gfilter = 1/(2*pi*sigma^2) * exp(-(X.^2 .* Y.^2)/(2*sigma^2));

end

