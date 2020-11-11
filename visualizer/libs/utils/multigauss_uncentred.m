function gauss_mat = multigauss_uncentred(variances,amplitudes,center,size_x,size_y)
%input: variances vector,their proportion
%output: total sum of the gausse curves with the given variances and the
%gauss curves themselves
[grid_x,grid_y]=meshgrid(1:size_x,1:size_y);
gauss_mat = 0;
for sub = 1:length(variances)
    gauss_mat = gauss_mat +  amplitudes(sub)*exp(-((grid_x-center(1)).^2+(grid_y-center(2)).^2)./((variances(sub)^2)*2));
end
end

