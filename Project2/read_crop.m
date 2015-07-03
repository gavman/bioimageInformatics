prompt = 'Enter the location of images. Please make a background folder in the same directory.';
str = input(prompt,'s');
imgstr = strcat(str,'\','001_a5_002_t001.tif');
img = imread(imgstr);
imshow(img);
rect = getrect;
for i=1:1:218
    p=sprintf('%03d',i);
    imgstr = strcat(str,'\','001_a5_002_t',p,'.tif');
imgn =imread (imgstr);
imgcrop = imcrop(imgn,rect);
crpstr = strcat(str,'\background\','background',p,'.tif');
imwrite(imgcrop,crpstr,'Compression','none');
end;