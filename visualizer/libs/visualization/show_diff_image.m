function show_diff_image(parameters, app, exp_num, im_num)
%SHOW_IMAGE Summary of this function goes here
%   Detailed explanation goes here
cla(app.ImageAxes)
[h,w] = size(parameters.images{exp_num}{im_num});
image(app.ImageAxes,(flip_matrix(parameters.images{exp_num}{im_num})-multigauss_uncentred(parameters.sigmas{exp_num}(im_num,:)/parameters.voxel_size{exp_num},...
    parameters.amplitudes{exp_num}(im_num,:),...
    parameters.centers{exp_num}(im_num,:),w,h)+parameters.intensities{exp_num}(im_num)).^2,'CDataMapping','scaled');
axis(app.ImageAxes,'tight');
end

