close all;
clear;
image_dir = 'E:\kuaipan\matlab\bioimage\pa2\BI_Project02_images';
magnification = [10, 20, 60, 100];
N = 4;
img_file = [num2str(magnification(N)), 'X_0', num2str(2 - ( N == 4)), '.tif'];
I = double(imread([image_dir, filesep, img_file]));
I_g = mat2gray(I);
thresh = graythresh(I_g);
I_bw = im2bw(I_g, thresh);
I_bw = imcomplement(I_bw);

figure, imshow(I_bw, []);

I_bw = imfilter(I_bw, fspecial('gaussian', 7, 1)) > 0.5;
% se = strel('disk', 20);
% I_bw = imopen(I_bw, se);
cc = bwconncomp(I_bw, 4);
obj_num = cc.NumObjects;
for i =1 : obj_num
    I_obj = false(size(I_bw));
    cc.PixelIdxList{i};
    I_obj(cc.PixelIdxList{i}) = true;
    cc_1 = bwconncomp(imcomplement(I_obj), 4);
    if cc_1.NumObjects == 5
        break;
    end  
end

figure, imshow(I_obj, []);

if N == 1 || N == 2
    se = strel('disk', 10 * N);
    I_bw_3 = imdilate(I_bw, se);
    figure, imshow(I_bw_3, []);
    cc = bwconncomp(I_bw_3, 4);
    [~, ind]= max(cell2mat(cellfun(@length, cc.PixelIdxList, 'uni', false)));
    im_scale_m = zeros(size(I_bw_3));
    im_scale_m(cc.PixelIdxList{ind}) = 1;
    im_scale = im_scale_m .* I_bw;
else
    im_scale = bwareaopen(I_bw, 500);
end
figure, imshow(im_scale, [])

im_boundary = true(size(I_bw));
im_boundary(2 : end - 1, 2 : end - 1) = false;
im_scale_label = bwlabel(im_scale);

boundary_vals = unique(im_scale_label(im_boundary));
% boundary_vals(boundary_vals == 0) = [];
im_scale(ismember(im_scale_label, boundary_vals )) = 0;
figure, imshow(im_scale, [])

im_cm = zeros(size(im_scale));
cc = bwconncomp(im_scale, 4);
obj_num = cc.NumObjects;
cm = zeros(obj_num, 2);
cm_center = [];

for i =1 : obj_num
ind =   cc.PixelIdxList{i};
[X, Y] = ind2sub(size(im_scale), ind);
cm(i, :) = [mean(X), mean(Y)];
im_cm(round(cm(i, 1)), round(cm(i, 2))) = 1;
end

se = strel('square', N * 2);
figure, imshow(im_scale, [])
figure, imshow(imdilate(im_cm, se), []);

im_color = zeros([size(im_cm), 3]);
im_color(:, :, 2) = imdilate(im_cm, se);
im_color(:, :, 3) = im_scale;
figure, imshow(im_color, []);

[X, Y] = ind2sub(size(I_obj), find(I_obj == 1));
cm_center = [mean(X), mean(Y)];

cm_h = cm(abs(bsxfun(@minus, cm(:,1), cm_center(1))) < 10, :);
cm_v = cm(abs(bsxfun(@minus, cm(:,2), cm_center(2))) < 10, :); 

im_cmh = zeros(size(im_scale));
im_cmh(sub2ind(size(im_scale), round(cm_h(:, 1)), round(cm_h(:, 2)))) = 1;
im_cmv = zeros(size(im_scale));
im_cmv(sub2ind(size(im_scale), round(cm_v(:, 1)), round(cm_v(:, 2)))) = 1;

figure, imshow(imdilate(im_cmh, se), []);
figure, imshow(imdilate(im_cmv, se), []);

[~, h_ind] = sort(cm_h(:, 2));
cm_h = cm_h(h_ind , :);
[~, v_ind] = sort(cm_v(:, 1));
cm_v = cm_v(v_ind, :);

ind_h = find(cm_h(:,2) == cm_center(:, 2));
ind_v = find(cm_v(:, 1) == cm_center(:, 1));

N_h = 40;
N_v = 40;

if N_h > ind_h || N_h > size(cm_h, 1) - ind_h + 1
    N_h = min(ind_h, size(cm_h, 1) - ind_h + 1);
end
if N_v > ind_v || N_v > size(cm_v, 1) - ind_v + 1
    N_v =  min(ind_v, size(cm_v, 1) - ind_v + 1);
end

X_pixel = 0.01 * N_h * 2 / (cm_h(ind_h + N_h - 1, 2 ) - cm_h(ind_h - N_h + 1, 2));

Y_pixel = 0.01 * N_v * 2 / (cm_v(ind_v + N_v - 1, 1 ) - cm_v(ind_v - N_v + 1, 1));


