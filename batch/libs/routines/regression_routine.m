function [diff_coeffs,coeffs_offset,...
    dim_vals,dim_offset,t0,...
    valid_matrix] = regression_routine(amps,sigmas,timestamps,parameters)
% input: amps - calculated amplitude values, sigmas - calculated sigma
% values, timestamps - time information of the images, parameters -
% evaluation parameters
% output: diff_coeffs - diffusion coefficients fitted by regression,
% coeffs_offset - y axis crossing for fitted diffusion coefficient line,
% dim_vals - fitted dimensionality values, dim_offset - y axis part for
% fitted dimensionality line
[num_im,num_sub] = size(amps);
if isempty('timestamps') || ~exist('timestamps','var')
    timestamps = 1:num_im;
    timestamps = timestamps./0.1;
end
% sort sigma and according amplitude values in asscending order
% here the assumption is that if a sigma value of a substance is smaller
% than another sigma value the successive sigma values of the substance
% will also be smaller then the values of the other substance
[amp_vals,sigma_vals,time_vals,valid_matrix]=simple_val_assign(amps,sigmas,timestamps,parameters.reg_acc);
diff_coeffs = 1:num_sub;
coeffs_offset = 1:num_sub;
dim_vals = 1:num_sub;
dim_offset = 1:num_sub;
t0 = 1:num_sub;
% perform a simple linear regression through the determined sigma and
% amplitude values to determine diffusion coefficient and dimensionality
for sub = 1:num_sub
    [v,m,b] = elr([sigma_vals{:,sub}].^2,[time_vals{:,sub}]);
    diff_coeffs(sub)=m/2;
    coeffs_offset(sub) = b;
    t0(sub) = calc_t0(m,b);
    [dim_vals(sub),dim_offset(sub)] = det_dim([amp_vals{:,sub}],[time_vals{:,sub}],t0(sub));
end
end

