function [ coordOk ] = coordWithinBoundOfImage( coord, gaussianKernelWidth, imHeight, imWidth )
%COORDWITHINGAUSSIANKERNELWIDTH return 1 of the coordinate is far enough
%within in the image that the entire gaussian kernel could overlap with it,
%0 otherwise

if (coord(1) > gaussianKernelWidth && coord(1) < (imHeight - gaussianKernelWidth) ...
        && coord(2) > gaussianKernelWidth && coord(2) < (imWidth - gaussianKernelWidth));
    coordOk = 1;
else
    coordOk = 0;
end

end

