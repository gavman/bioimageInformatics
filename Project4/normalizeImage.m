function [ I_out ] = normalizeImage( I_in, newMin,newMax )
%normalizeImage Takes uint16 or uint8 and scales to uint8. Returns as
%double

Idbl = double(I_in);
I_out = (Idbl - min(Idbl(:)))*(newMax - newMin)/(max(Idbl(:)) - min(Idbl(:))) + newMin;

end

