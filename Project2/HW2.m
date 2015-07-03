%% Project 2

%% Part 1
%% 1.1
sigmas = [1, 2, 5, 7]';
[im, cmap] = imread('image01.tiff');
figure;
for i = 1:size(sigmas)
    % filter image
    sigma = sigmas(i);
    gaussianFilter = gaussianfilter(sigma);
    imLP = filter2(gaussianFilter, im);
    
    % plot
    subplot(2, 2, i);
    imshow(imLP, cmap);
    title(['Sigma = ' num2str(sigma)]);
end

%% 1.2
[im, cmap] = imread('image01.tiff');
sigmas = [1 2 5]';
figure;
for i = 1:size(sigmas)
    % filter image-->Lecture 8 slide 29
    sigma = sigmas(i);
    gaussianFilter = gaussianfilter(sigma);
    [dx, dy] = my_imgradientxy(gaussianFilter);
    derImx = filter2(dx, im);
    derImy = filter2(dy, im);
    
    % plot x
    subplot(3, 2, 2*i - 1);
    imshow(derImx, cmap);
    title(['Sigma = ' num2str(sigma) ' ,dir = x']);
    
    % plot y
    subplot(3, 2, 2*i);
    imshow(derImy, cmap);
    title(['Sigma = ' num2str(sigma) ' ,dir = y']);
    
end

%% 1.3 (Bonus)
% http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1217270
sigmau = 10;
sigmav = 5;
thetas = [30, 60, 90, 120, 150]'
[im, cmap] = imread('image01.tiff');
figure;
subplot(3, 2, 1);
imshow(im, cmap);
title('Original Image');
for i = 1:size(thetas)
    % filter image
    theta = thetas(i);
    h = anisotropicgaussian(sigmau, sigmav, theta);
    imFiltered = filter2(h, im);
    
    % plot
    subplot(3, 2, i+1);
    imshow(imFiltered, cmap);
    title(['Theta = ' num2str(theta)]);
end

%% 3.1
% http://en.wikipedia.org/wiki/Airy_disk
lambdas = [480, 520, 680, 520, 520, 680]';
as = [.5, .5, .5, 1, 1.4, 1.5]';
colors = ['y', 'm', 'c', 'r', 'g', 'b'];
legendStrs = {};

figure;
for i = 1:size(lambdas)
    lambda = lambdas(i);
    a = as(i);
    k = 2*pi/(lambda*10^-9);
    theta = linspace(-pi, pi, 100);
    I = ((2*besselj(0, k*a.*sin(theta)))./(k*a.*sin(theta))).^2;
    I = I./max(I);
    legendStr = ['Lambda = ' num2str(lambda) ', NA = ' num2str(a)];
    legendStrs{1, i} = legendStr;
    plot(k*a.*sin(theta), I, colors(i));
    hold on;
end

legend(legendStrs);

