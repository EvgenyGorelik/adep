function [profile,grid] = concentrical_sum_v1(image,center)
%input: matrix and center for radial sum calculation with samples step radius devision
%output: profile vector

[width,height] = size(image);
radius = min([center(1) width-center(1) center(2) height-center(2)]);

step_size=1-mod(radius,1);
grid=-radius:step_size:radius;
grid_size=length(grid);
profile = zeros(1,grid_size);

%defines radius moving closer to the center, with radius/samples as
%stepsize
rho = 0:step_size:radius;
%angle for calculation of the polar coordinates
theta = 0:1/grid_size:2*pi;

for i = 1:length(theta)
    [x,y] = pol2cart(theta(i),rho);
    x = uint8(x+center(1));
    y = uint8(y+center(2));
    %building mean value of the array of values
    mean_val = image(sub2ind(size(image),x,y));
    profile(1:round(end/2)) = (fliplr(mean_val)+profile(1:round(end/2)));
    profile(round(end/2)+1:end) = (mean_val(2:end)+profile(round(end/2)+1:end));
end
profile=profile/length(theta);
end

