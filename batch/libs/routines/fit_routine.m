function [amps,sigmas,profiles,grids,centers,ground_intensities] = fit_routine(image_stack,parameters)
% input: image_stack - stack of images, parameters - evaluation parameters
% output: amps - fitted amplitudes, sigmas - fitted sigma values, profiles
% - vectors with gaussian distributed values, grids - vectors with
% according grid values, centers - determined center coordinates,
% ground_intensities - base levels for intensity normalization

% initialize variables
[~,~,im_num] = size(image_stack);
amps = zeros(im_num,parameters.sub_num);
sigmas = zeros(im_num,parameters.sub_num);
profiles = cell(im_num,1);
grids = cell(im_num,1);
centers = zeros(im_num,2);
ground_intensities = zeros(im_num,1);

for i = 1:im_num
    % apply filter noise filter if required
    if(strcmp(parameters.filter,'Gaussian'))
        img = gaussian_denoise(image_stack(:,:,i),parameters.gaussian_sigma,parameters.gaussian_size);
    elseif(strcmp(parameters.filter,'Fourier'))
        img = fourier_denoise_2D(image_stack(:,:,i),parameters.fourier_cutoff);
    else
        img = image_stack(:,:,i);
    end
    img = double(flip_matrix(img));
    % determine center coordinate of gaussian distribution
    if(strcmp(parameters.center,'Discrete Integration'))
        centers(i,:) = gaussian_detection(img);
    elseif(strcmp(parameters.center,'Maximal Value'))
        centers(i,:) = max_detection(img);
    elseif(strcmp(parameters.center,'Point Symmetry'))
        centers(i,:) = sym_correct(img,gaussian_detection(img));
    else
        centers(i,:) = circular_detection_v2(img);
    end
    % create profile from each image for reduced data fitting
    if(strcmp(parameters.profile,'Concentric Sum'))
        [profile,grid_v] = concentrical_sum(img, centers(i,:));
    else
        [profile,grid_v] = distributed_profile(img, centers(i,:), parameters.radial_thresh);
    end
    % scale grid vector
    grid_v = pix_to_um(grid_v,parameters.voxel_size);
    % normalize ground intensities to zero
    ground_intensities(i) = level_norm_edge(img,5);
    profile = profile - ground_intensities(i);
    % fit sigma and amplitude values for every image
    if(strcmp(parameters.fit,'Powell Method'))
        p = powel_method_v1(grid_v, profile, parameters.sub_num, parameters.powell_prec);
    else
        p = profile_fit(grid_v, profile, parameters.sub_num);
    end
    profiles{i} = profile;
    grids{i} = grid_v;
    amps(i,:) = p(1:2:end);
    sigmas(i,:) = p(2:2:end);
end

