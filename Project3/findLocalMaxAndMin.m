function [localMaximaMask, localMinimaMask] = findLocalMaxAndMin( im ,maskSize)
%findLocalMaxAndMin Summary of this function goes here
%   Detailed explanation goes here

if(maskSize ~= 3 && maskSize~=5)
   error('Only mask size of 3 or 5 is supported'); 
end


globalMinValue = 0;
globalMaxValue = max(im(:))+65;

if(maskSize ==3)
   padded4max  = padarray(im, [1 1],globalMinValue);
   padded4min  = padarray(im, [1 1],globalMaxValue);
   
   [numRows, numCols] = size(padded4max);
   
   numRowsOrig = numRows -2;
   numColsOrig = numCols -2;
   localMaximaMask = false(numRowsOrig, numColsOrig);
   localMinimaMask = localMaximaMask;
   
   startRow = 2;  % Index of real matrix in padded matrix
   startCol =2;
   
   dispX = 1;
   dispY=1;
  
   
   for icol= 0:numColsOrig-1
       for irow = 0:numRowsOrig-1
           col = icol+startCol;
           row = irow+startRow;           
           rowStart = row-dispY;
           rowEnd = row+dispY;
           colStart = col-dispX;
           colEnd = col+dispX;
            
           centerValue1 = padded4max(row, col);
           centerValue2 = padded4min(row, col);
           assert(isequal(centerValue1,centerValue2));
           
           maxSubSection = padded4max(rowStart:rowEnd, colStart:colEnd);
           minSubSection = padded4min(rowStart:rowEnd, colStart:colEnd);
           if(numel(maxSubSection(maxSubSection >= centerValue1)) == 1)
               %isLocalMaxima
               localMaximaMask(irow+1, icol+1) =1;
           end
           if(numel(minSubSection(minSubSection <= centerValue1)) == 1)
               %isLocalMinima
               localMinimaMask(irow+1, icol+1) =1;
           end
       end
   end
   
    
elseif(maskSize ==5)
   padded4max  = padarray(im, [2 2],globalMinValue);
   padded4min  = padarray(im, [2 2],globalMaxValue);
   
   [numRows, numCols] = size(padded4max);
   numRowsOrig = numRows -4;
   numColsOrig = numCols -4;
   localMaximaMask = false(numRowsOrig, numColsOrig);
   localMinimaMask = localMaximaMask; 
    
   startRow = 3;
   startCol =3;
   
   
   dispX = 2;
   dispY =2;   

   for icol= 0:numColsOrig-1
       for irow = 0:numRowsOrig-1
           col = icol+startCol;
           row = irow+startRow;           
           rowStart = row-dispY;
           rowEnd = row+dispY;
           colStart = col-dispX;
           colEnd = col+dispX;
            
           centerValue1 = padded4max(row, col);
           centerValue2 = padded4min(row, col);
           assert(isequal(centerValue1,centerValue2));
           
           maxSubSection = padded4max(rowStart:rowEnd, colStart:colEnd);
           minSubSection = padded4min(rowStart:rowEnd, colStart:colEnd);
           if(numel(maxSubSection(maxSubSection >= centerValue1)) == 1)
               %isLocalMaxima
               localMaximaMask(irow+1, icol+1) =1;
           end
           if(numel(minSubSection(minSubSection <= centerValue1)) == 1)
               %isLocalMinima
               localMinimaMask(irow+1, icol+1) =1;
           end
       end
   end   
   
end

end

