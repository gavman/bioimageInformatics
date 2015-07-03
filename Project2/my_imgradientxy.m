function [ dx, dy ] = my_imgradientxy( im )
%MY_IMGRADIENTXY my version of imgradient

%circularly shift by col/row
imshiftcol = circshift(im, 1, 2);
imshiftrow = circshift(im, 1);

%subtract from original
dx = bsxfun(@minus,im,imshiftcol);
dy = bsxfun(@minus,im,imshiftrow);

end

