function [ h ] = anisotropicgaussian( sigmau, sigmav, theta )
% Calculate the anisotropic gaussian filter

threeSigmau = 3*sigmau;
threeSigmav = 3*sigmav;
[X, Y] = meshgrid(-threeSigmau:threeSigmau, -threeSigmav:threeSigmav);

% Equation 5 in the paper
const = 1/(2*pi*sigmau*sigmav);
uTerm = (((X.*cosd(theta) + Y.*sind(theta)).^2)/sigmau^2);
vTerm = (((-X.*sind(theta) + Y.*cosd(theta)).^2)/sigmav^2);
expon = exp(-.5*(uTerm+vTerm));
h = const*expon;

end

