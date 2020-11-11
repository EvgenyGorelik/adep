function center_coor = gaussian_detection_v2(matrix)
%input: matrix - image containing gaussian_distribution
%output: center_coor - coordinates in picture detected by gaussian 

[width,height] = size(matrix);
gauss_x = zeros(width,1);
for i = 1:height %iterates through rows
    gauss_x(i) = sum(matrix(i,:));
end
gauss_y = zeros(height,1);
for i = 1:width %iterates through columns
    gauss_y(i) = sum(matrix(:,i));
end
center_coor = zeros(1,2);

sim_fun = @(p,v,v_size) sum((p(1)*exp(-((1:v_size)-p(3)).^2/(2*p(2)^2))-transpose(v-mean(v))).^2);
% fit integral to gaussian function along y axis
p = [max(gauss_x-mean(gauss_x)),calc_variance_1D(gauss_x-mean(gauss_x)),height/2];
p = fminsearch(@(p) sim_fun(p,gauss_x,height),p);
center_coor(1) = p(3);
% fit along x axis
p = [max(gauss_y-mean(gauss_y)),calc_variance_1D(gauss_y-mean(gauss_y)),width/2];
p = fminsearch(@(p) sim_fun(p,gauss_y,width),p);
center_coor(2) = p(3);
end

