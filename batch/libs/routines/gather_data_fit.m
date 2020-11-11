function [amps,sigmas,profiles,grids] = gather_data_fit(parent, parameters)
% input: parent - app for console output, parameters - fitting parameters
% output: amps - amplitudes of diffusion images, sigmas - sigma values of 
% diffusion images, profiles - y values of diffusion images, grids - x 
% values of diffusion images

log_message("---------------ADEP-FRAP Evaluation Log---------------", parameters.log_file);
log_message("###This log contains evaluation of FRAP experiments###", parameters.log_file);
log_message(strcat("Evaluation started: ",datestr(datetime('now'))), parameters.log_file);
log_message(strcat("Parent directory is: ",parent), parameters.log_file);

% find image, bckg and leica file paths 
[img_paths, bckg_paths, leica_paths] = find_data_routine(parent, parameters.bckg_name, parameters.img_name, parameters.img_type, parameters.leica_name, parameters.leica_type);

% log number of folders with images
log_message(strcat("Found ",num2str(length(img_paths))," folders."), parameters.log_file);
parameters.main_app.ConsoleTextArea.Value{end+1} = char("Found " + num2str(length(img_paths)) + " folders with images.");
drawnow
% no folders, no calculation
if(isempty(img_paths))
    return
end

% iterate through folders and evaluate individual diffusion experiments
for i = 1:length(img_paths)
    im_num = length(img_paths{i});
    image_cells = cell(im_num,1);
    log_message("Found Images: ", parameters.log_file);
    for num = 1:im_num
        image_cells{num} = double(imread(img_paths{i}(num)));
        log_message(img_paths{i}(num), parameters.log_file);
    end
    % load images into stack
    image_stack = cat(3,image_cells{:});
    bckg_num = 0;
    if(~isnumeric(bckg_paths{i}))
        bckg_num = length(bckg_paths{i});
        bckg_cells = cell(bckg_num,1);
        log_message("Found Backgrounds: ", parameters.log_file);
        % load all found bckg images into cells
        for num = 1:bckg_num
            bckg_cells{num} = double(imread(bckg_paths{i}(num)));
            log_message(bckg_paths{i}(num), parameters.log_file);
        end
        if(~isempty(bckg_cells))
            bckg_avg = 0;
            % calculate average of bckg images for subtraction from
            % image_stack
            for num = 1:bckg_num
                bckg_avg = bckg_avg + bckg_cells{num};
            end
            % calculate avg bckg image
            bckg_avg = bckg_avg/bckg_num;
            % iterate through image stack and subtract bckg
            for num = 1:im_num
                image_stack(:,:,num) = image_stack(:,:,num)-bckg_avg;
            end
        end
    end
    % check for leica file
    if(~isfile(leica_paths(i)))
        log_message("No Leica File Found. Using voxel size = 1 and timestamp interval = 1s.",parameters.log_file);
    end
    % get leica parameters, if empty, default values are assigned
    [timestamps,voxels] = read_leica(im_num, bckg_num, leica_paths(i));
    % log calculation parameters
    parameters.voxel_size = voxels;
    log_message(strcat("Got Voxel Size [um/pixel]: ",num2str(voxels)),parameters.log_file);
    log_message("Got Times [s]: ",parameters.log_file);
    log_matrix(timestamps,size(timestamps,1),parameters.log_file);
    timestamps = timestamps - timestamps(1);
    log_message(strcat("Center Detection: ",num2str(parameters.center)),parameters.log_file);
    log_message(strcat("Maximal Allowed Shift of Center: ",num2str(parameters.center_threshold)),parameters.log_file);
    log_message(strcat("Filter Method: ",num2str(parameters.filter)),parameters.log_file);
    log_message(strcat("Profile Creation: ",num2str(parameters.profile)),parameters.log_file);
    if(strcmp(parameters.profile,"Radial Distribution"))
        log_message(strcat("Radial Distribution Binning Threshold: ",num2str(parameters.radial_thresh)),parameters.log_file);
    end
    % if use_diff_fit is not set the images are evaluated independently
    if(parameters.use_diff_fit == 0)
        if(parameters.det_sub == 1)
            % determine number of substances
            [parameters.sub_num,~] = n_sub(image_stack, parameters.sample_num, 5);
        end
        log_message(strcat("Fitting Method: ",num2str(parameters.fit)),parameters.log_file);
        log_message(strcat("Calculation for ",num2str(parameters.sub_num)," substances."),parameters.log_file);
        [amps,sigmas,profiles,grids,centers,base_level] = fit_routine(image_stack,parameters);
        % load amplitudes and sigmas into regression function
        [diff_coeffs,coeffs_offset,...
            dim_vals,dim_offset,t0,...
            valid_matrix] = regression_routine(amps, sigmas, timestamps, parameters);
    else
        log_message(strcat("Fitting Method: ","Diffusion Model"),parameters.log_file);
        % otherwise, load image stack and according timestamps
        [diff_coeffs,sigmas,amps,centers,base_level,weigth,t0,dim_vals,~] = diff_fit_routine(image_stack,timestamps,parameters);
    end
    % log determined features
    parameters.sub_num = length(diff_coeffs);
    log_message("Detected Centers (x,y):",parameters.log_file);
    log_matrix(centers, size(centers,1), parameters.log_file);
    log_message("Calculated Ground Intensities:",parameters.log_file);
    log_matrix(base_level, size(base_level,1), parameters.log_file);
    log_message("Calculated Amplitudes:",parameters.log_file);
    log_matrix(amps, size(amps,1), parameters.log_file);
    log_message("Calculated Sigmas:",parameters.log_file);
    log_matrix(sigmas, size(sigmas,1), parameters.log_file);
    if(parameters.use_diff_fit == 0)
        log_message("Of those used for Calculation:",parameters.log_file);
        log_matrix(valid_matrix, size(valid_matrix,1), parameters.log_file);
    end
    log_message(strcat("Calculated Diffusion Coeffecients [um^2/s]: ",num2str(transpose(diff_coeffs))),parameters.log_file);
    if(parameters.use_diff_fit == 1)
        log_message(strcat("Calculated Amounts: ",num2str(transpose(weigth))),parameters.log_file);
    end
    log_message(strcat("Calculated t0 [s]: ",num2str(transpose(t0))),parameters.log_file);
    log_message(strcat("Calculated dimensionality: ",num2str(transpose(dim_vals))),parameters.log_file);
    if(parameters.use_diff_fit == 1)
        log_message(strcat("Calculated Total Residuum: ",num2str(total_res(image_stack,sigmas,amps.*transpose(weigth),centers))),parameters.log_file);
    else
        log_message(strcat("Calculated Total Residuum: ",num2str(total_res(image_stack,sigmas,amps,centers))),parameters.log_file);
    end
    parameters.main_app.ConsoleTextArea.Value{end+1} = char("Stack " + num2str(i) + "/" + num2str(length(img_paths)) + " completed.");
    drawnow
end

