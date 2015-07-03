function [ coords ] = findMaxOrMins( im, maskSize )
%FINDMAXORMINS Finds all local maxes or mins in im using a maskSize by
%maskSize window. maskSize must be odd.
% Returns Nx3 matrix with [x y minOrMax] in each row, where x and y are
% pixel coordinates and minOrMax is 0 for a min and 1 for a max

coords = [];
maskCenter = (maskSize + 1)/2;

% add padding
padding = (maskSize - 1)/2;
im = padarray(im, padding);

% check that mask is smaller than image
[imRows, imCols] = size(im);
if (imRows < maskSize || imCols < maskSize)
    error('Mask larger than image');
end

for row = 1:imRows - maskSize + 1
    for col = 1:imCols - maskSize + 1
        rect = [col row maskSize-1 maskSize-1];
        window = imcrop(im, rect);
        minOrMax = isLocalMinOrMax(window);
        if (minOrMax > 0)
            coords = [coords; row+maskCenter col+maskCenter minOrMax-1];
        end
    end
end

end