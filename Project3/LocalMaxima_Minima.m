function [Local_max, Local_min] = LocalMaxima_Minima(I, mask_size)

[m, n] = size(I);
pad_l = (mask_size - 1) / 2;
I_max_p = padarray(I, [pad_l, pad_l]);
I_min_p = padarray(I, [pad_l, pad_l], max(I(:)) + 1)
Local_max = zeros(m, n);
Local_min = zeros(m, n);

for i = 1 : m
    for j = 1 : n
        center = I_max_p(i + pad_l, j + pad_l);
        max_window = I_max_p(i : i + mask_size - 1, j : j + mask_size - 1);
        max_window(pad_l + 1, pad_l + 1) = center - 1;
        if all(max_window(:) < center)
            Local_max(i, j) = 1;
        end
        
        min_window = I_min_p(i : i + mask_size - 1, j : j + mask_size - 1);
        min_window(pad_l + 1, pad_l + 1) = center + 1;
        if all(min_window(:) > center)
            Local_min(i, j) = 1;
        end 
    end
end

end