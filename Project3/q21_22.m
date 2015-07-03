close all

%% 2.1 - Calibration Of Dark Noise
imname = 'images/001_a5_002_t001.tif';
[I, cmap] = imread(imname);
assert(isempty(cmap));
I = double(I);
figure,imshow(I, [])

% Cropping a dark region
[noise_crop, rect] = imcrop;

noise_crop = (noise_crop);
noise_vec = noise_crop(:);
noise_mean = mean(noise_vec)
noise_std  = std(noise_vec)

%% 2.2 Detection Of Local Maxima and Local Minima

imname = 'images/001_a5_002_t001.tif';
[I, cmap] = imread(imname);
assert(isempty(cmap));
I = double(I);

% Gaussian filter w 1/3 Rayleigh radius
% Constants
lambda = 515 ; % nm
NA = 1.4;
nmPerPixel = 65;

R = .61 * lambda / NA;
sigma = 1/3 * R; % nanomaters
sigmaInPixels = sigma/nmPerPixel;

% We want 3 sigma in each direction
hsize = round(sigmaInPixels*6);

h = fspecial('gaussian', hsize, sigmaInPixels);
imFiltered = imfilter(I, h);
figure, imshow(imFiltered,[]);
title(['Gaussian Filtered Image: Sigma ', num2str(sigma), ' nm']);

% Local Maxima and Minima Search
% 3x3 mask
[localMaximaMask3, localMinimaMask3] = findLocalMaxAndMin(imFiltered,3);
figure, imshow(localMaximaMask3),title('Local Maxima 3x3 Mask');

% 5x5 mask
[localMaximaMask5, localMinimaMask5] = findLocalMaxAndMin(imFiltered,5);
figure, imshow(localMaximaMask5), title('Local Maxima 5x5 Mask')

save('localMaximaMask5.mat','localMaximaMask5');

% Use the overlay function from lane labeling

