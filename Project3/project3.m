%% Bioimage Informatics Project 7
% Group 7

%% Setup -- run before any problem
imname = 'images/001_a5_002_t001.tif';
[im, cmap] = imread(imname);
im = im2double(im);

% Constants
NA = 1.4;
lambda = 515;
pixelSize = 65;

% Find sigma in terms of pixels
r = 0.61*lambda/NA;
sigma = r/3;
sigmaPixels = sigma/pixelSize;
gfilter = gaussianFilter(sigmaPixels);

% Gaussian filter for B.3.2
pixelSizeB32 = 13;
sigmaPixelsB32 = sigma/pixelSizeB32;
gfilterB32 = gaussianFilter(sigmaPixelsB32);

%% B.2

%% B.2.1
%f = figure;
%imshow(i, cmap);
%rect = getrect(f);
rect = [600, 37, 385, 63]; %result from gerect
i2 = imcrop(im, rect);
ave = mean(i2(:)); % 305.2234 or 74.7976
stdev = std(i2(:), 1); % 24.1289 or 3.6818e-04
imwrite(i2, 'b221_crop.png');

%% B.2.2
% Filter
im2 = filter2(gfilter, im);

% Find mins and maxes
coords3 = findAllLocalMaxOrMins(im2, 3);
coords5 = findAllLocalMaxOrMins(im2, 5);

% Show mins and maxes on the image
figure;
subplot(3, 1, 1);
imshow(im2, cmap);
title('Original Image Filtered');
subplot(3, 1, 2);
plotImMinMax(im2, cmap, coords3);
title('Mins and maxes of 3x3 mask');
subplot(3, 1, 3);
plotImMinMax(im2, cmap, coords5);
title('Mins and maxes of 5x5 mask');

%% B.2.3
% Put 2.3 here

%% B.2.4
% Put 2.4 here

%% B.3

%% B.3.1
coords = coords5;
% Take out just the maxes, then the first two columns with coordinates
coordsMax = coords(coords(:,3) == 1,:);
coords = coordsMax(:,1:2);

raw_image = createRawImage(coords, im);
figure,imshow(raw_image,[]),title('Raw image');

% Convolve with Gaussian
% Filter
i2 = filter2(gfilter, im);
i3 = awgn(i2, 5,'measured');

%% B.3.2

% Upsample by 5 --> resize by 5
resampleFactor = 5;
imOversampled = imresize(im, resampleFactor);

% For every coordinate of a max, apply the gaussian fit to find sub-pixel
% coordinate that best matches the gaussian
coords = coords5;
coordsMax = coords(coords(:,3) == 1,:);
coords = coordsMax(:,1:2);

% This assumes that the particle is far enough within the bounds of the
% upsampled filter that the gaussian kernel can fit over it without going
% out of the bounds of the image. All particles next to the very edge of
% the upsampled image will be ignored
newCoords = [];
gaussianKernelWidth = (size(gfilterB32,1)-1)/2;
[imHeight, imWidth] = size(imOversampled);
for i = 1:size(coords,1)
    %1 indexing sucks--zero index, move, back to 1 index
    coord = ((coords(i, :) - [1 1])*resampleFactor)+[1 1];
    % if the kernel will fit, find the new sub-pixel coordinates
    if coordWithinBoundOfImage(coord, gaussianKernelWidth, imHeight, imWidth);
        newCoord = findSubpixelBestFit(coord, imOversampled, gfilterB32, resampleFactor, gaussianKernelWidth);
        newCoords = [newCoords; newCoord];
    end
end

% Plot result of sub-pixel detections
figure;
imshow(imOversampled, cmap);
hold on;
for i = 1:size(newCoords, 1)
    thisCoord = newCoords(i,:);
    plot(thisCoord(2), thisCoord(1), 'r.');
end