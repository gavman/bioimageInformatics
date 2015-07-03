function [ h ] = airyPattern(r)
%airyPattern Summary of this function goes here
%   Detailed explanation goes here
    if(r ==0)
        h =1;
    else
         h = 2* besselj(1,(2*pi*r)) ./(2*pi*r);
    end  
end