function [profile,grid] = concentrical_sum(image,center)
% input: image - data matrix with gaussian distribution, center - gaussian
% distribution center coordinates
% output: profile - vector with concentrical averaged values, grid - grid vector
% for counteracting size variation

% determine image dimensions and smallest distance from the center to an
% image border
[width,height] = size(image);
radius = min([center(1) width-center(1) center(2) height-center(2)]);
% define stepsize based on precision of the center
step_size=1-mod(radius,1);
% create grid vector and corresponding value vector 
grid=-radius:step_size:radius;
grid_size=length(grid);
profile = zeros(1,grid_size);
% define radius vector which stepwise increases its distance to the image
% center
rho = 0:step_size:radius;
% define angle vector for calculation of the polar coordinates
theta = 0:1/grid_size:2*pi;
for i = 1:length(rho)
    % translate the polar coordinates defined by radius value rho(i) to
    % cartesian coordinates
    [x,y] = pol2cart(theta,rho(i));
    % round values so they can be used as integer
    x = uint8(x+center(1));
    y = uint8(y+center(2));
    % create mean value for all (x,y) values in the matrix
    mean_val = mean(image(sub2ind(size(image),x,y)));
    % assign values to the profile at both sides from the vector center so
    % the center of the matrix stays in the middle
    profile(round(end/2)+(i-1)) = mean_val;
    profile(round(end/2)-(i-1)) = mean_val;
end
end

