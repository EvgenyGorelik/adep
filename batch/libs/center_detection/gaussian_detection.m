function center_coor = gaussian_detection(img)
%input: img - image containing gaussian diffusion
%output: center_coor - discrete x and y coordinate of distribution center

[width,height] = size(img);
gauss_x = zeros(width,1);
for i = 1:height %iterates through rows
    gauss_x(i) = sum(img(i,:));
end
gauss_y = zeros(height,1);
for i = 1:width %iterates through columns
    gauss_y(i) = sum(img(:,i));
end

%find maximal values with according indeces
[~,x_max_index]=max(gauss_x);
[~,y_max_index]=max(gauss_y);
center_coor = [x_max_index,y_max_index];