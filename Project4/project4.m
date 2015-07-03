%% Bioimage Informatics Spring 2015 Project 4
% Group 7
close all
clear variables
addpath(genpath('project4_data'));

%% NOTES
% http://designest.de/2009/11/matitk-additional-documentation/ is very
% useful

%% C.2.1
im1 = imread('project4_data/60x_02.tif');
im2 = imread('project4_data/Blue0001.tif');

Inorm1 = normalizeImage(im1, 1, 255);
imgSz = size(Inorm1);
D1 = zeros(imgSz(1),imgSz(2),2);
D1(:,:,1) = Inorm1;
D1(:,:,2) = Inorm1;

Inorm2 = normalizeImage(im2, 1, 255);
imgSz = size(Inorm2);
D2 = zeros(imgSz(1),imgSz(2),2);
D2(:,:,1) = Inorm2;
D2(:,:,2) = Inorm2;

%% SIC

% pick seeds based on image
im1_seeds = [536 318 1 790 482 1];
im2_seeds = [268 205 1 140 140 1];

b1 = matitk('SIC', [1 255], uint8(D1), uint8([]), im1_seeds);
figure; imagesc(squeeze(b1(:,:,2))); colormap gray; axis off; axis equal;

b2 = matitk('SIC', [1 255], uint8(D2), uint8([]), im2_seeds);
figure; imagesc(squeeze(b2(:,:,2))); colormap gray; axis off; axis equal;

%% SNC

im1_seed = [790 482 1];
im2_seed = [140 140 1];


% SNC
% radius x, radius y, radius z, min, max, replacement
b = matitk('SNC', [5 5 1 10 170 255], uint8(D1), uint8([]), [2 2 1]);
figure; imagesc(squeeze(b(:,:,2))); colormap gray; axis off; axis equal;

b = matitk('SNC', [10 10 1 1 100 255], uint8(D2), uint8([]), im2_seed);
figure; imagesc(squeeze(b(:,:,2))); colormap gray; axis off; axis equal;

%% C 2.2
clear variables

files = dir('project4_data/Mito_GFP_a01/*.tif');

%% SIC

% compute SIC threshold on image sequence
writerObj = VideoWriter('SICmovie.avi');
open(writerObj);
for i =1:numel(files)
    I1 = imread(files(i).name);
    Inorm1 = normalizeImage(I1, 1, 255);
    imgSz = size(Inorm1);
    D1 = zeros(imgSz(1),imgSz(2),2);
    D1(:,:,1) = Inorm1;
    D1(:,:,2) = Inorm1;

    im1_seeds = [24 24 1 282 130 1 ];

    b = matitk('SIC', [1 255], uint8(D1), uint8([]), im1_seeds);
    fr = squeeze(b(:,:,2));
    % Uncomment to view in real time
    %h=figure; imagesc(fr); colormap gray; axis off; axis equal; 
    %pause(1);
    %close(h)
    writeVideo(writerObj,fr);
end
close(writerObj);
implay('SICmovie.avi');

%% SNC
% compute SIC threshold on image sequence
writerObj = VideoWriter('SNCmovie.avi');
open(writerObj);
for i =1:numel(files)
    I1 = imread(files(i).name);
    Inorm1 = normalizeImage(I1, 1, 255);
    imgSz = size(Inorm1);
    D1 = zeros(imgSz(1),imgSz(2),2);
    D1(:,:,1) = Inorm1;
    D1(:,:,2) = Inorm1;

    im2_seeds = [24 24 1];

    b = matitk('SNC', [10 10 1 1 100 255], uint8(D1), uint8([]), im2_seeds);
    fr = squeeze(b(:,:,2));
    % Uncomment to view in real time
%    h=figure; imagesc(fr); colormap gray; axis off; axis equal; 
   % pause;
   % close(h)
    writeVideo(writerObj,fr);
end
close(writerObj);
implay('SNCmovie.avi');


%% Calculating Metrics On 3 frames
addpath(genpath('project4_data'));
files = dir('project4_data/Mito_GFP_a01/*.tif');

frame10 = imread(files(10).name);
frame15 = imread(files(15).name);
frame20 = imread(files(20).name);

% Calculate mask for frame10
sz = size(frame10);
frame10mask = logical(zeros(sz));
figure, imshow(frame1,[]);
inputStr= input('Continue labeling image? (y/n)','s');

while(isequal(inputStr, 'y'))
    hFH = imfreehand();
    tmpMask = hFH.createMask();
    frame10mask = frame10mask | tmpMask;
    h = figure; imshow(frame10mask);
    inputStr= input('Ok. Continue labeling image? (y/n)','s');
    close(h);
end
    
% Calculate mask for frame15
sz = size(frame15);
frame15mask = logical(zeros(sz));
figure, imshow(frame1,[]);
inputStr= input('Continue labeling image? (y/n)','s');

while(isequal(inputStr, 'y'))
    hFH = imfreehand();
    tmpMask = hFH.createMask();
    frame15mask = frame15mask | tmpMask;
    h = figure; imshow(frame15mask);
    inputStr= input('Ok. Continue labeling image? (y/n)','s');
    close(h);
end


% Calculate mask for frame20
sz = size(frame20);
frame20mask = logical(zeros(sz));
figure, imshow(frame1,[]);
inputStr= input('Continue labeling image? (y/n)','s');

while(isequal(inputStr, 'y'))
    hFH = imfreehand();
    tmpMask = hFH.createMask();
    frame20mask = frame20mask | tmpMask;
    h = figure; imshow(frame20mask);
    inputStr= input('Ok. Continue labeling image? (y/n)','s');
    close(h);
end

save('handmasks.mat', 'frame10mask', 'frame15mask', 'frame20mask');

%% 
clear variables

load('handmasks.mat');

% SIC
addpath(genpath('project4_data'));
files = dir('project4_data/Mito_GFP_a01/*.tif');

frame10 = imread(files(10).name);
frame15 = imread(files(15).name);
frame20 = imread(files(20).name);

Inorm10 = normalizeImage(frame10, 1, 255);
imgSz = size(Inorm10);
D10 = zeros(imgSz(1),imgSz(2),2);
D10(:,:,1) = Inorm10;
D10(:,:,2) = Inorm10;

im1_seeds = [24 24 1 282 130 1 ];
b = matitk('SIC', [1 255], uint8(D10), uint8([]), im1_seeds);
fr10 = squeeze(b(:,:,2));
fr10 = ~logical(fr10);


Inorm15 = normalizeImage(frame15, 1, 255);
imgSz = size(Inorm15);
D15 = zeros(imgSz(1),imgSz(2),2);
D15(:,:,1) = Inorm15;
D15(:,:,2) = Inorm15;

im1_seeds = [24 24 1 282 130 1 ];
b = matitk('SIC', [1 255], uint8(D15), uint8([]), im1_seeds);
fr15 = squeeze(b(:,:,2));
fr15 = ~logical(fr15);


Inorm20 = normalizeImage(frame20, 1, 255);
imgSz = size(Inorm20);
D20 = zeros(imgSz(1),imgSz(2),2);
D20(:,:,1) = Inorm20;
D20(:,:,2) = Inorm20;

im1_seeds = [24 24 1 282 130 1 ];
b = matitk('SIC', [1 255], uint8(D20), uint8([]), im1_seeds);
fr20 = squeeze(b(:,:,2));
fr20 = ~logical(fr20);

[volOverlapE] = calcMetrics(frame10mask, frame15mask, frame20mask, fr10,fr15, fr20);

%% SNC
frame10 = imread(files(10).name);
frame15 = imread(files(15).name);
frame20 = imread(files(20).name);

Inorm10 = normalizeImage(frame10, 1, 255);
imgSz = size(Inorm10);
D10 = zeros(imgSz(1),imgSz(2),2);
D10(:,:,1) = Inorm10;
D10(:,:,2) = Inorm10;

im2_seeds = [24 24 1];
b = matitk('SNC', [10 10 1 1 100 255], uint8(D10), uint8([]), im2_seeds);
fr10 = squeeze(b(:,:,2));
fr10 = ~logical(fr10);


Inorm15 = normalizeImage(frame15, 1, 255);
imgSz = size(Inorm15);
D15 = zeros(imgSz(1),imgSz(2),2);
D15(:,:,1) = Inorm15;
D15(:,:,2) = Inorm15;

im2_seeds = [24 24 1];
b = matitk('SNC', [10 10 1 1 100 255], uint8(D15), uint8([]), im2_seeds);
fr15 = squeeze(b(:,:,2));
fr15 = ~logical(fr15);


Inorm20 = normalizeImage(frame20, 1, 255);
imgSz = size(Inorm20);
D20 = zeros(imgSz(1),imgSz(2),2);
D20(:,:,1) = Inorm20;
D20(:,:,2) = Inorm20;

im2_seeds = [24 24 1];
b = matitk('SNC', [10 10 1 1 100 255], uint8(D20), uint8([]), im2_seeds);
fr20 = squeeze(b(:,:,2));
fr20 = ~logical(fr20);

[volOverlapE] = calcMetrics(frame10mask, frame15mask, frame20mask, fr10,fr15, fr20);

