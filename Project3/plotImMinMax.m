function [ ] = plotImMinMax( i2, cmap, coords )
%PLOTIMMINMAX Plot an image with its local min and max

imshow(i2, cmap);
hold on;
for i = 1:size(coords, 1)
    type = 'r.';
    if (coords(i, 3) == 0)
        type = 'g+';
    end
    plot(coords(i, 2), coords(i, 1), type);
end

end

