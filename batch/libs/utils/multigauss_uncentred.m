function gauss_mat = multigauss_uncentred(variances,amplitudes,center,size_x,size_y)
% input: variances - sigma values, amplitudes - distribution amplitudes,
% center - coordinates of the center of the distribution, size_x - size in
% x direction, size_y - size in y direction
% output: gauss_mat - gaussian distributed matrix with shiftet center
[grid_x,grid_y]=meshgrid(1:size_x,1:size_y);
gauss_mat = 0;
for sub = 1:length(variances)
    gauss_mat = gauss_mat +  amplitudes(sub)*exp(-((grid_x-center(1)).^2+(grid_y-center(2)).^2)./((variances(sub)^2)*2));
end
end

