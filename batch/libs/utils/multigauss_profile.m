function profile = multigauss_profile(variances,amplitude,grid_v)
%input: variances vector,their proportion
%output: total sum of the gausse curves with the given variances and the
%gauss curves themselves
if isempty('grid_v') || ~exist('grid_v','var')
    grid_v = 0:100;
end
if isempty('amplitude') || ~exist('amplitude','var')
    amplitude = 1;
end
% calculate gaussian value for every value in the grid vector
profile = zeros(length(grid_v),1);
for i = 1:length(variances)
    profile = profile + amplitude(i)*exp(-(grid_v).^2./(2*variances(i)^2));
end
end


