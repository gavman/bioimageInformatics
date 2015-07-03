function [ minOrMax ] = isLocalMinOrMax( im )
%ISLOCALMINORMAX Is the point in the middle of the mas a min or a max
% Return 0 if neither, 1 if min, 2 if max
% Note: assumes imCrop is MxN where M and N are odd

% Find the center of the mask
im = im(:);
midpoint = (length(im) + 1)/2;

% Replace the midpoint with something tiny and something huge
% Used to test if midpoint max/min is > or >= all other values
imMidpointTiny = im;
imMidpointTiny(midpoint) = -1;
imMidpointHuge = im;
imMidpointHuge(midpoint) = 1000;

minOrMax = 0;
if ((min(im) == im(midpoint)) && (min(imMidpointHuge) > min(im)))
    minOrMax = 1;
elseif ((max(im) == im(midpoint)) && (max(imMidpointTiny) < max(im)))
    minOrMax = 2;
end

end

