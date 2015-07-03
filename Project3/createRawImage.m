function [ rawImage ] = createRawImage(coords, origImage)
%createRawImage 

rawImage = uint16(zeros(size(origImage)));
linIndxs = sub2ind(size(origImage), coords(:,1), coords(:,2));
rawImage(linIndxs) = origImage(linIndxs);

end

