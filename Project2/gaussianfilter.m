function [ gfilter ] = gaussianfilter( sigma )
%GAUSSIANFILTER
% Create a gaussian filter with variance sigma

threeSigma = 3*sigma;
[X, Y] = meshgrid(-threeSigma:threeSigma, -threeSigma:threeSigma);
gfilter = 1/(2*pi*sigma^2) * exp(-(X.^2 .* Y.^2)/(2*sigma^2));

end