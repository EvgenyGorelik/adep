classdef function_parameters
    % Parameter settings for profile fitting    
    properties
        % Find Images and Data
        bckg_name = 'Preview';
        img_name = 'Series';
        leica_name = 'FRAP_Simu';
        img_type = 'tif';
        leica_type = 'txt';
        log_file = 'C:\tmp\ADEP_batch.log'
        % Level Normalisation
        level_norm_method = 'Edge';
        % alternative: Statistic
        level_edge_incl = 5;
        % Image Noise Filtering
        filter = 'None';
        % alternative: Gaussian, Fourier
        fourier_cutoff = 20;
        gaussian_sigma = 2;
        gaussian_size = 7;
        % Center Detection
        center = 'Discrete Integration';
        % alternative: 
        % Maximal Value, Circular Center, Point Symmetry, Gaussian Fit
        center_threshold = 30;
        % Data Reduction
        profile = 'Radial Distribution';
        % alternative: Concentric Sum
        radial_thresh = 20;
        % Substance Detection
        sub_num = 1;
        det_sub = 0;
        sample_num = 8;
        det_sub_acc = 0.8;
        skip = 6;
        % Profile Fitting
        fit = 'Diffusion Fitting';
        % alternative: Profile Fitting, Simulated Annealing
        powell_threshold = 2;
        powell_max_n = 5;
        powell_prec = 10^-6;
        fit_init_n = 1;
        reg_acc = 0.6
        % Diffusion Fitting
        use_diff_fit = 1;
        det_dim = 0;
        diff_dim = 2;
        prf_fit_from = 1;
        prf_fit_to = 3;
        correct_level = 0;
        fit_skip = 6;
        simulated_annealing = 0;
        sim_an_step = 0.001;
        % Main App
        main_app = 0;
        voxel_size = 1;
    end
end

