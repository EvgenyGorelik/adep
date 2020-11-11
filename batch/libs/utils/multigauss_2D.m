function [sum,gauss_matrix] = multigauss_2D(variances,amplitude,proportion,sample_size)
%input: variances vector,their proportion
%output: total sum of the gausse curves with the given variances and the
%gauss curves themselves
if isempty('sample_size') || ~exist('sample_size','var')
    sample_size = 100;
end
if isempty('proportion') || ~exist('proportion','var')
    proportion = ones(length(variances),1)/length(variances);
end
if isempty('amplitude') || ~exist('amplitude','var')
    amplitude = 1;
end

% create grid
[x_coor,y_coor] = meshgrid(-sample_size/2:sample_size/2-1,-sample_size/2:sample_size/2-1);

gauss_matrix = zeros(sample_size,sample_size,length(variances));
sum = 0;
% for every coordinate in grid calculate according gaussian value
for i = 1:length(variances)
    gauss_matrix(:,:,i) = amplitude(i)*exp(-((x_coor).^2 + (y_coor).^2)./(2*variances(i)^2));
    sum = sum + gauss_matrix(:,:,i).*proportion(i);
end
end


