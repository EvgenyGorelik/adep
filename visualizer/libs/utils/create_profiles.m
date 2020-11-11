function parameters = create_profiles(parameters)
%RE_FIT Summary of this function goes here
%   Detailed explanation goes here
for exp=1:parameters.exp_num
    n = length(parameters.images{exp});
    [w,h] = size(parameters.images{exp}{1});
    img = zeros(w,h,n);
    parameters.profiles{exp} = cell(n,1);
    parameters.grid_v{exp} = cell(n,1);
    bckg_avg = 0;
    if(~isempty(parameters.backgrounds{exp}))
        bckg_num = length(parameters.backgrounds{exp});
        for i = 1:bckg_num
            bckg_avg = bckg_avg + parameters.backgrounds{exp}{i};
        end
        if(bckg_num)
            bckg_avg = bckg_avg/bckg_num;
        end
    end
    for i = 1:n
        img(:,:,i) = flip_matrix(parameters.images{exp}{i}-bckg_avg);
        if(strcmp(parameters.filter_method,'Gaussian'))
            img(:,:,i) = double(gaussian_denoise(img(:,:,i),parameters.gaussian_sigma,parameters.gaussian_size));
        elseif(strcmp(parameters.filter_method,'Fourier'))
            img(:,:,i) = double(fourier_denoise_2D(img(:,:,i),parameters.fourier_cutoff));
        else
            img(:,:,i) = double(img(:,:,i));
        end
        if(strcmp(parameters.prof_method,'Concentric Sum'))
            [parameters.profiles{exp}{i},parameters.grid_v{exp}{i}] = concentrical_sum(img(:,:,i), parameters.centers{exp}(i,:));
        else
            [parameters.profiles{exp}{i},parameters.grid_v{exp}{i}] = distributed_profile(img(:,:,i), parameters.centers{exp}(i,:), parameters.radial_thresh{exp});
        end
        [parameters.profiles{exp}{i}] = [parameters.profiles{exp}{i}]-parameters.intensities{exp}(i);
    end
    parameters.timestamps{exp} = parameters.timestamps{exp}-parameters.timestamps{exp}(1);
end
end

