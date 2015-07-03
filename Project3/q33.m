function q33_parallel

clear, close all;
directory = ['~/projects/15-0405'];
image_dir = [directory, filesep, 'images'];
outputdir = [directory, filesep, 'outputs'];

addpath(genpath(directory));

if ~exist(outputdir, 'dir')
    mkdir(outputdir);
end

lambda = 515;
NA = 1.4;
pixel_size = 65;
sigma = 0.61 * lambda / NA / 3 / pixel_size;

image_name = dir(image_dir);
image_name(1:2) = [];
I = double(imread([image_dir, filesep, image_name(1).name]));
I_smooth = imfilter(I, fspecial('gaussian',  round(sigma * 6), sigma));

mask_size = 5;
[I_max , ~] = LocalMaxima_Minima(I_smooth, mask_size);
SNR = 20;
MaxIter = 1000;
Err = zeros(MaxIter, 1);

for j = 1 : MaxIter
    
    temp_name = [outputdir, filesep, 'img', num2str(j), '.temp'];
    img_name = [outputdir, filesep, 'synthesized_images', filesep, 'image_', num2str(j, '%04d'), '.tif'];
    raw_param_name = [outputdir, filesep, 'rawdata', filesep, 'rawdata_', num2str(j, '%04d'), '.mat'];
    subpixel_name = [outputdir, filesep, 'subpixel', filesep, 'subpixel_', num2str(j, '%04d'), '.mat'];

    if ~exist([outputdir, filesep, 'synthesized_images'], 'dir')
        mkdir([outputdir, filesep, 'synthesized_images']);
    end
    if ~exist([outputdir, filesep, 'rawdata'], 'dir')
        mkdir([outputdir, filesep, 'rawdata']);
    end
    if ~exist([outputdir, filesep, 'subpixel'], 'dir')
        mkdir([outputdir, filesep, 'subpixel']);
    end
    if exist(img_name,'file') && exist(raw_param_name,'file') && exist(subpixel_name,'file') || exist(temp_name,'file')
        disp('The image is finished or being working somewhere else');
        continue;
    else    
        fclose(fopen(temp_name, 'w'));
    end

    I_WN  = image_generation(I, I_max, SNR);
    imwrite(uint16(I_WN), img_name, 'compression', 'none');
    % sigma = sqrt(var(I_WN(:), 1));
    % I_smooth = imfilter(I_WN, fspecial('gaussian',  3, 0.5));

    [I_wn_max, ~] = LocalMaxima_Minima(I_WN, 5);

    [m, n] = size(I_WN);

    [Y_max, X_max] = ind2sub([m, n], find( I_wn_max == 1));        

    fold = 5;
    fm = fold * m;
    fn = fold * n;
    mask_size = 35;
    pad_l = ceil((mask_size - 1) / 2);

    h_fold = (fold + 1) / 2;
    I_os = im_oversampling( I_WN, fold);
    I_padding = padarray(I_os, [pad_l, pad_l]);
    param_cell = zeros(size(Y_max, 1), 7);
    point_param = [];
    for i = 1 : length(Y_max)
        y_i = Y_max(i);
        x_i = X_max(i);
        y_c = (y_i - 1) * fold + h_fold + pad_l;
        x_c = (x_i - 1) * fold + h_fold + pad_l;
        window = I_padding(y_c - pad_l : y_c + pad_l, x_c - pad_l : x_c + pad_l);
        options = optimset('MaxFunEvals', 1e9, 'MaxIter', 5e3, 'Display', 'off');
        %MaxIter
        [param_i, fval] = fminsearch(@(param) Gaussian_fit_err( param, window), [1, 1, pad_l + 1, pad_l + 1], options);   
        param_cell(i, :) = [param_i, [x_i, y_i], fval];

        param_i = param_cell(i, :);    
        if mean(I_WN(:)) < param_i(1) && param_i(1) < 1e4 && 0 < param_i(3) && param_i(3) <= mask_size ...
                && 0 < param_i(4) && param_i(4) < mask_size  
            point_param = [point_param; param_i];
        end

    end

    save(raw_param_name, 'param_cell');

    [~, ind] = sort(point_param(:, 1));
    point_param_s = point_param(ind, :);
    save(subpixel_name, 'point_param_s');

    X_sub = point_param_s(:, 5);
    Y_sub = point_param_s(:, 6);

    im_sub = zeros(size(I_max));

    im_sub(sub2ind(size(im_sub), Y_sub, X_sub)) = 1;

    im_correct = im_sub .* I_max;

    err = sum(sum(im_sub - im_correct + I_max - im_correct));
    Err(j) = err;

    save([outputdir, filesep, 'error'], 'Err');

    if exist(subpixel_name,'file') && exist(temp_name, 'file')
        delete(temp_name);
    end
end
save([outputdir, filesep, 'error'], 'Err');

end

function I_WN = image_generation(I, I_max, SNR)

lambda = 515;
NA = 1.4;
pixel_size = 65;
sigma = 0.61 * lambda / NA / 3 / pixel_size;

I_raw = I;
I_raw(~I_max) = 0;
I_gaussian = imfilter(I_raw,  fspecial('gaussian',  round(sigma * 6), sigma));
I_WN = double(uint16(awgn(I_gaussian, SNR, 'measured')));
end


function [Local_max, Local_min] = LocalMaxima_Minima(I, mask_size)

[m, n] = size(I);
pad_l = (mask_size - 1) / 2;
I_max_p = padarray(I, [pad_l, pad_l]);
I_min_p = padarray(I, [pad_l, pad_l], max(I(:)) + 1);
Local_max = zeros(m, n);
Local_min = zeros(m, n);

for i = 1 : m
    for j = 1 : n
        center = I_max_p(i + pad_l, j + pad_l);
        max_window = I_max_p(i : i + mask_size - 1, j : j + mask_size - 1);
        max_window(pad_l + 1, pad_l + 1) = center - 1;
        if all(max_window(:) < center)
            Local_max(i, j) = 1;
        end
        
        min_window = I_min_p(i : i + mask_size - 1, j : j + mask_size - 1);
        min_window(pad_l + 1, pad_l + 1) = center + 1;
        if all(min_window(:) > center)
            Local_min(i, j) = 1;
        end 
    end
end

end


function I = im_oversampling(img, fold, type)

if nargin < 3 
    type = 'linear';
elseif nargin < 2
    fold = 5;
elseif nargin < 1
    error('please provide an image!');
end

[m, n] = size(img);
fm = m * fold;
fn = n * fold;
I = zeros(fm, fn);
step = 1 / fold;
I_padding = padarray(img,[1, 1], 'both');
[X, Y] = meshgrid(0 : n + 1, 0 : m + 1);
[Xq, Yq] = meshgrid( step * round((fold + 1 ) / 2): step : n + step * round((fold - 1 ) / 2), ...
    step * round((fold + 1 ) / 2) : step : m + step * round((fold - 1 ) / 2));
    
if strcmp(type, 'nearest')
    I = interp2( X, Y, I_padding, Xq, Yq, 'nearest');
elseif strcmp(type, 'linear')
    I = interp2( X, Y, I_padding, Xq, Yq);
elseif strcmp(type, 'cubic')
    I = interp2( X, Y, I_padding, Xq, Yq, 'cubic');
elseif strcmp(type, 'spline')
    I = interp2( X, Y, I_padding, Xq, Yq, 'spline');
end
end


function Err = Gaussian_fit_err(param, I)
A = param(1);
B = param(2);
x0 = param(3);
y0 = param(4);

[m, n] = size(I);
x = 1 : n;
y = (1 : m)';
if ~B
    B = 1e-10;
end
G = A * exp(-bsxfun(@plus, bsxfun(@minus, x, x0) .^ 2, bsxfun(@minus, y, y0) .^ 2) / B);
Err = sum(sum((G - I) .^ 2));
end