% Read the results from prob 2.2
imname = 'images/001_a5_002_t001.tif';
[I, cmap] = imread(imname);
I = double(I);

load localMaximaMask5.mat

sz = size(localMaximaMask5);
linInds = find(localMaximaMask5==1);
[Rows, Cols] = ind2sub(sz, linInds);

coords = horzcat(Rows,Cols);
%coordsMax = coords(coords(:,3) == 1,:);
%coords = coordsMax(:,1:2);

raw_image = createRawImage(coords, I);
figure,imshow(raw_image,[]),title('Raw image');

raw_image = double(raw_image);
% Convolve with Gaussian
% Filter
lambda = 515 ; % nm
NA = 1.4;
nmPerPixel = 65;

R = .61 * lambda / NA;
sigma = 1/3 * R; % nanomaters
sigmaInPixels = sigma/nmPerPixel;
% We want 3 sigma in each direction
hsize = round(sigmaInPixels*6);
h = fspecial('gaussian', hsize, sigmaInPixels);
i2 = imfilter(raw_image, h);
figure, imshow(i2, []),title('Synthetic Image : Raw Image Convolved with PSF');
i3 = awgn(i2, 20, 'measured'); % Add gaussian noise

figure, imshow(i3,[]), title('Synthetic Image With Gaussian Noise- SNR: 20');