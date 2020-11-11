function [diff_coeff,o_sig,o_amps,centers,base_level,o_weigth,o_t0,o_dimens,res] = diff_fit_routine(img,timestamps,parameters)
% input: img - image stack, timestamps - time signatures of images,
% parameters - parameters for fitting
% output: diff_coeff - calculated diffusion coefficient, o_sig - calculated
% sigma values, o_amps - calculated amplitudes, base_level - ground
% intesity, o_weight - weights of individual substances, o_t0 -
% extrapolated t0 values for individual substances, res - residuum of
% parameters

% get number of image
n = size(img,3);

global profile
global grid_v
profile = cell(n,1);
grid_v = cell(n,1);
centers = zeros(n,2);
base_level = zeros(n,1);

% batch through the individual images and perform normalizations
for i = 1:n
    % if required apply noise filter
    if(strcmp(parameters.filter,'Gaussian'))
        img(:,:,i) = gaussian_denoise(img(:,:,i),parameters.gaussian_sigma,parameters.gaussian_size);
    elseif(strcmp(parameters.filter,'Fourier'))
        img(:,:,i) = fourier_denoise_2D(img(:,:,i),parameters.fourier_cutoff);
    end
    % flip matrix values along mean values
    img(:,:,i) = double(flip_matrix(img(:,:,i)));
    % choose method for finding distribution center coordinate
    if(strcmp(parameters.center,'Discrete Integration'))
        centers(i,:) = gaussian_detection(img(:,:,i));
    elseif(strcmp(parameters.center,'Maximal Value'))
        centers(i,:) = max_detection(img(:,:,i));
    elseif(strcmp(parameters.center,'Gaussian Fit'))
        centers(i,:) = gaussian_detection_v2(img(:,:,i));
    elseif(strcmp(parameters.center,'Point Symmetry'))
        centers(i,:) = sym_correct(img(:,:,i),gaussian_detection(img(:,:,i)));
    else
        centers(i,:) = circular_detection_v2(img(:,:,i));
    end
    % assure, that a non-negative center was found
    if(isnan(centers(i,:)))
        centers(i,:) = gaussian_detection_v2(img(:,:,i));
    end
    % assure, that center differs not to much from previous center
    % based on assumption, that center for a huge amplitude is calculated
    % more stable
    if(i > 1)
        if(norm(centers(i,:)-centers(i-1,:))>parameters.center_threshold)
            centers(i,:) = centers(i-1,:);
        end
    end
    % create gaussian profile out of image
    if(strcmp(parameters.profile,'Concentric Sum'))
        [profile{i},grid_v{i}] = concentrical_sum(img(:,:,i), centers(i,:));
    else
        [profile{i},grid_v{i}] = distributed_profile(img(:,:,i), centers(i,:), parameters.radial_thresh);
    end
    % scale grid dependet on voxel size
    grid_v{i} = pix_to_um(grid_v{i},parameters.voxel_size);
    % calculate ground intensity
    if(strcmp(parameters.level_norm_method,'Statistic'))
        [~,base_level(i)]=level_norm([profile{i}]);
    else
        base_level(i) = level_norm_edge(img(:,:,i),5);
    end
    % normalize ground intensity to zero
    [profile{i}] = [profile{i}]-base_level(i);
end
% determine substance number if required
if(parameters.det_sub == 1)
    parameters.sub_num = n_sub_prof(grid_v,profile,parameters.sample_num,parameters.det_sub_acc);
elseif(parameters.det_sub == 2)
    parameters.sub_num = n_sub_prof_det(grid_v{parameters.sample_num},profile{parameters.sample_num},parameters.det_sub_acc);
end
sub_n = parameters.sub_num;
log_message(strcat("Calculation for ",num2str(sub_n)," substance/s."),parameters.log_file);
start_from = parameters.prf_fit_from;
up_to = parameters.prf_fit_to;
% profile_fit_v2 takes a sample of profiles and uses line search to fit
% sigma and amplitude values
[prf_v2,~] = profile_fit_v2({grid_v{start_from:up_to}},{profile{start_from:up_to}},timestamps(start_from:up_to),sub_n);
prf_diff_coef = zeros(sub_n,1);
% prognose diffusion coefficient from to successive sigma values and their
% timestamps
for sub = 1:sub_n
    prf_diff_coef(sub) = abs((prf_v2(2*sub)^2-prf_v2(2*sub + 2)^2)/(timestamps(2)-timestamps(1)))/2;
end
log_message(strcat("Prognosed Diffusion Coefficient: ",num2str(transpose(prf_diff_coef))),parameters.log_file);
% if selected, adjust levels, so the successive ground intensities fit the
% prognosed diffusion coefficient better
if(parameters.correct_level == 1)
    for i = 4:n
        profile{i} = profile{i} + correct_level([grid_v{i}],[profile{i}],[timestamps(2) timestamps(i)],prf_v2((sub_n*2)+1:2:end),prf_v2((sub_n*2)+2:2:end),prf_diff_coef);
    end
end
% if the dimensionality must be determined it is set to zero so the
% algorithm knows it has to be included in the calculation
if(parameters.det_dim == 1)
    parameters.diff_dim = 0;
end
% simulated annealing and diffusion fitting using nelder mead both require
% a fixed sigma sample to reduce the degrees of freedom
if(parameters.simulated_annealing == 0)
    [diff_coeff,o_sig,o_amps,o_weigth,o_t0,o_dimens,res] = ...
        diff_fit(grid_v, profile, timestamps, parameters.fit_skip, prf_v2(2:2:sub_n*2), prf_v2(1:2:sub_n*2), ...
        (prf_v2((sub_n*2)+1:2:end).^2)./(prf_v2(1:2:sub_n*2).^2), parameters.diff_dim, sub_n, prf_diff_coef);
else
    [diff_coeff,o_sig,o_amps,o_weigth,o_t0,o_dimens,res] = ...
        simulated_annealing(grid_v, profile, timestamps, parameters.fit_skip, prf_v2(2:2:sub_n*2), prf_v2(1:2:sub_n*2), ...
        (prf_v2((sub_n*2)+1:2:end).^2)./(prf_v2(1:2:sub_n*2).^2), parameters.diff_dim, sub_n, parameters.sim_an_step);
end
end

