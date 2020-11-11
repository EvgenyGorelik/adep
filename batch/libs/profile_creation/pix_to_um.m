function grid_v = pix_to_um(grid_v,scale_size)
% input: grid_v - vector containing grid values, scale_size - pixel to mu
% meter relation
% output: grid_v - scaled grid
grid_v = grid_v*scale_size;
end

