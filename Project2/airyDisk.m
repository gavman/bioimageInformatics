function [ I , sp] = airyDisk( lambda, NA )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    k = 2*pi/(lambda*10^-9);
    theta = linspace(-pi, pi, 100);
    I = ((2*besselj(1, k*NA.*sin(theta)))./(k*NA.*sin(theta))).^2;
    I = I./max(I);
    sp = k*NA.*sin(theta);
end

