
pixsize_x(4) = zeros;
pixsize_y(4) = zeros;
for i=1:1:4
%i=1;
prompt = 'Enter the images.';
str = input(prompt,'s');
   % p=sprintf('%02d',iloop(i));
imgstr = strcat(str,'.tif');
img = imread(imgstr);
%imgbw = im2bw(img,0.08);
%%se = strel('disk',4);
%imc = imclose(imgbw,se);
imshow(img,[]);
%prompt = 'Enter 2 mm rectangle in x.';
%str = input(prompt,'s');
rect = getrect;
npix_x = rect(1)+rect(3);
pixsize_x(i) = npix_x/2;
%prompt = 'Enter 2 mm rectangle in y.';
imshow(img,[]);
rect = getrect;
npix_y = rect(2)+rect(4);
pixsize_y(i) = npix_y/2;
end;
