function [values,m,b] = welr(values,grid_v,weights)
%input: pairs of values and gridpoints for which regression is calculated
%output: values of regressed line, slope m and y crossing b
if isempty('grid_v') || ~exist('grid_v','var')
    grid_v = 1:length(values);
end
% weighted linear regression 
x_avg = mean(grid_v);
y_avg = mean(values.*transpose(weights));
s_xy = sum((values.*weights-y_avg).*(grid_v-x_avg));
s_yy = sum((values.*weights-y_avg).^2);
m = s_yy/s_xy;
b = y_avg - m*x_avg;
values = grid_v.*m+b;
end

