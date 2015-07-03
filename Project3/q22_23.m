clear, close all;

%image_dir = 'E:\kuaipan\matlab\bioimage\pa3\images';
%outputdir = ['E:\kuaipan\matlab\bioimage\pa3\', filesep, 'smoothed_images'];
%image_name = dir(image_dir)
%image_name(1:2) = [];
%I = imread([image_dir, filesep, image_name(1).name]);
I = imread('images/001_a5_002_t001.tif');
figure, imshow(I,[]);
% if ~exist(outputdir, 'dir')
%     mkdir(outputdir);
% end
lambda = 515;
NA = 1.4;
pixel_size = 65;
sigma = 0.61 * lambda / NA / 3 / pixel_size;

% for i = 1:length(image_name)
%     imagei_name = image_name(i).name;
%     Ii = double(imread([image_dir, filesep, imagei_name]));
%     imshow(Ii, []);
%     Ii_smooth = imfilter(Ii, fspecial('gaussian',  round(sigma * 6), sigma));
%     imwrite(mat2gray(Ii_smooth), [outputdir, filesep, 'image_', imagei_name(end - 6 : end)], 'compression', 'none');   
% end 

%imagei_name = image_name(1).name;
%Ii = double(imread([image_dir, filesep, imagei_name]));
%imshow(Ii, []);
I_smooth = imfilter(I, fspecial('gaussian',  round(sigma * 6), sigma));



mask_size = 5;
[I_MAX,~] = LocalMaxima_Minima(I_smooth, mask_size);

[m, n] = size(I_smooth);
pad_l = (mask_size - 1) / 2;
I_padding = padarray(I_smooth, [pad_l, pad_l]);

Local_max = zeros(m, n);
Local_min = zeros(m, n);

for i = 1 : m
    for j = 1 : n
        center = I_padding(i + pad_l, j + pad_l);
        window = I_padding(i : i + mask_size - 1, j : j + mask_size - 1);
        window(pad_l + 1, pad_l + 1) = center - 1;
        if all(window(:) < center)
            Local_max(i, j) = 1;
        end 
        window(pad_l + 1, pad_l + 1) = center + 1;
        if all(window(:) > center)
            Local_min(i, j) = 1;
        end 
    end
end
se = strel('disk', 3);
im_color = zeros([m, n, 3]);
im_color(:, :, 1) = imdilate(Local_max, se);
% im_color(:, :, 2) = imdilate(Local_min, se);
threshold = graythresh(mat2gray(I_smooth));
im_color(:, :, 3) = mat2gray(I_smooth) > threshold ;
figure, imshow(im_color, []);


 imwrite(Local_max, [outputdir, filesep, 'local_maximum.tif'], 'compression', 'none');
 imwrite(Local_min, [outputdir, filesep, 'local_minimum.tif'], 'compression', 'none');
       
[Y, X] = ind2sub([m, n], find( Local_min == 1));
[Y_max, X_max] = ind2sub([m, n], find( Local_max == 1));        
figure
TRI = delaunay(X, Y);
triplot(TRI, X, Y)
hold on;
scatter(X_max, Y_max);
hold off
figure
TRI = delaunay(X_max, Y_max);
triplot(TRI, X_max, Y_max)
hold on;
scatter(X, Y);
hold off

P_max = [X_max, Y_max];
P_min = [X, Y];
I_ind = im_knn(P_max, P_min, 3);


rect = [600, 37, 385, 63]; %result from gerect
I_bg = double(imcrop(Ii, rect));
bg_mean = mean(I_bg(:));
bg_sigma = sqrt(var(I_bg(:), 1));

I_localmax = Ii(sub2ind([m, n], Y_max, X_max));
delta_I = abs(bsxfun(@minus, I_localmax, bg_mean));
sigma_delta_I = 1 / sqrt(3) * bg_sigma;
T = delta_I / sigma_delta_I;
Q_alpha = 3.090;

H = (T >= Q_alpha);

Y_max_n = Y_max(H);
X_max_n = X_max(H);

Local_max_n = zeros(m, n);
Local_max_n(sub2ind([m, n], Y_max_n, X_max_n)) = 1;
figure, imshow(Local_max, [])
figure, imshow(Local_max_n, [])

figure, plot(H)
delta_I_1 = zeros(size(delta_I));
delta_I_1(H) = delta_I(H);
figure, plot(delta_I_1);
