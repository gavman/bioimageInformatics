function [ newCoord ] = findSubpixelBestFit( coord, imOversampled, gfilter, resampleFactor, gaussianKernelWidth )
%FINDSUBPIXELBESTFIT Find the subpixel that best fits the gaussian filter
gkw = gaussianKernelWidth;

minEi = -1;
minEj = -1;
minEnergy = 0;
for i = coord(1):coord(1)+resampleFactor
    for j = coord(2):coord(2)+resampleFactor
        thisRect = [j-gkw, i-gkw, 2*gkw, 2*gkw];
        imUnderKernel = imcrop(imOversampled, thisRect);
        energy = sum(sum(abs(imUnderKernel - gfilter)));
        if (minEi == -1 || energy > maxEnergy)
            minEi = i;
            minEj = j;
            minEnergy = energy;
        end
    end
end

newCoord = [minEi minEj];

end

