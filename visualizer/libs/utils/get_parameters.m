function parameters = get_parameters(log_path)
%GET_PARAMETERS Summary of this function goes here
%   Detailed explanation goes here
parameters = total_parameters;
fd = fopen(log_path);
line = fgetl(fd);
if(contains(line,"ADEP-FRAP Evaluation Log"))
    line = fgetl(fd);
end
exp_count = 1;
while(line ~= -1)
    if(contains(line,"folders."))
        parameters.exp_num = str2double(strip(erase(erase(line,'Found'),'folders.')));
        parameters.sub_nums = cell(parameters.exp_num,1);
        parameters.exp_names = cell(parameters.exp_num,1);
        parameters.timestamps = cell(parameters.exp_num,1);
        parameters.t0_values = cell(parameters.exp_num,1);
        parameters.diff_coefs = cell(parameters.exp_num,1);
        parameters.weights = cell(parameters.exp_num,1);
        parameters.images = cell(parameters.exp_num,1);
        parameters.image_names = cell(parameters.exp_num,1);
        parameters.radial_thresh = cell(parameters.exp_num,1);
        parameters.center_detect = cell(parameters.exp_num,1);
        parameters.prof_method = cell(parameters.exp_num,1);
        parameters.filter_method = cell(parameters.exp_num,1);
        parameters.fit_method = cell(parameters.exp_num,1);
        parameters.backgrounds = cell(parameters.exp_num,1);
        parameters.centers = cell(parameters.exp_num,1);
        parameters.intensities = cell(parameters.exp_num,1);
        parameters.profiles = cell(parameters.exp_num,1);
        parameters.grid_v = cell(parameters.exp_num,1);
        parameters.amplitudes = cell(parameters.exp_num,1);
        parameters.sigmas = cell(parameters.exp_num,1);
        line = fgetl(fd);
    end
    if(contains(line,"Found Images:"))
        line = fgetl(fd);
        split_line = split(line,'\');
        parameters.exp_names{exp_count} = split_line{end-1};
        parameters.images{exp_count} = cell(1);
        parameters.images{exp_count}{1} = double(imread(line));
        parameters.image_names{exp_count}{1} = split_line{end};
        line = fgetl(fd);
        while 1
            try
                parameters.images{exp_count}{end+1} = double(imread(line));
                split_line = split(line,'\');
                parameters.image_names{exp_count}{end+1} = split_line{end};
                line = fgetl(fd);
            catch
                break;
            end
        end
    end
    if(contains(line,"Found Backgrounds:"))
        line = fgetl(fd);
        parameters.backgrounds{exp_count} = cell(1);
        parameters.backgrounds{exp_count}{1} = double(imread(line));
        line = fgetl(fd);
        while 1
            try
                parameters.backgrounds{exp_count}{end+1} = double(imread(line));
                line = fgetl(fd);
            catch
                break;
            end
        end
    end
    if(contains(line,"Got Voxel"))
        parameters.voxel_size{exp_count} = str2double(strip(erase(line,"Got Voxel Size [um/pixel]: ")));
        line = fgetl(fd);
    end
    if(contains(line,"Got Times"))
        n = length(parameters.images{exp_count});
        parameters.timestamps{exp_count} = zeros(n,1);
        line = fgetl(fd);
        for i = 1:n
            parameters.timestamps{exp_count}(i) = str2double(strip(line));
            line = fgetl(fd);
        end
    end
    if(contains(line,"Center Detection: "))
        parameters.center_detect{exp_count} = strip(erase(line,"Center Detection: "));
        line = fgetl(fd);
    end
    if(contains(line,"Filter Method: "))
        parameters.filter_method{exp_count} = strip(erase(line,"Filter Method: "));
        line = fgetl(fd);
    end
    if(contains(line,"Profile Creation: "))
        parameters.prof_method{exp_count} = strip(erase(line,"Profile Creation: "));
        line = fgetl(fd);
    end
    if(contains(line,"Fitting Method: "))
        parameters.fit_method{exp_count} = strip(erase(line,"Fitting Method: "));
        line = fgetl(fd);
    end
    if(contains(line,"Calculation for"))
        parameters.sub_nums{exp_count} = str2double(strip(erase(erase(line,"Calculation for"),"substance/s.")));
        line = fgetl(fd);
    end
    if(contains(line,"Fitting Method: "))
        parameters.fit_method{exp_count} = strip(erase(line,"Fitting Method: "));
        line = fgetl(fd);
    end
    if(contains(line,"Radial Distribution Binning Threshold: "))
        parameters.radial_thresh{exp_count} = str2double(strip(erase(line,"Radial Distribution Binning Threshold: ")));
        line = fgetl(fd);
    end
    if(contains(line,"Detected Centers"))
        n = length(parameters.images{exp_count});
        parameters.centers{exp_count} = zeros(n,2);
        line = fgetl(fd);
        for i = 1:n
            split_line = split(line);
            split_line = split_line(~cellfun('isempty',split_line));
            parameters.centers{exp_count}(i,:) = str2double(split_line(1:end));
            line = fgetl(fd);
        end
    end
    if(contains(line,"Calculated Ground Intensities:"))
        n = length(parameters.images{exp_count});
        parameters.intensities{exp_count} = zeros(n,1);
        line = fgetl(fd);
        for i = 1:n
            parameters.intensities{exp_count}(i) = str2double(strip(line));
            line = fgetl(fd);
        end
    end
    if(contains(line,"Calculated Amplitudes:"))
        n = length(parameters.images{exp_count});
        parameters.amplitudes{exp_count} = zeros(n,parameters.sub_nums{exp_count});
        line = fgetl(fd);
        for i = 1:n
            split_line = split(line);
            split_line = split_line(~cellfun('isempty',split_line));
            parameters.amplitudes{exp_count}(i,:) = str2double(strip(split_line));
            line = fgetl(fd);
        end
    end
    if(contains(line,"Calculated Sigmas:"))
        n = length(parameters.images{exp_count});
        parameters.sigmas{exp_count} = zeros(n,parameters.sub_nums{exp_count});
        line = fgetl(fd);
        for i = 1:n
            split_line = split(line);
            split_line = split_line(~cellfun('isempty',split_line));
            parameters.sigmas{exp_count}(i,:) = str2double(strip(split_line));
            line = fgetl(fd);
        end
    end
    if(contains(line,"Calculated Diffusion Coeffecients [um^2/s]:"))
        parameters.diff_coefs{exp_count} = str2double(strip(split(erase(line,"Calculated Diffusion Coeffecients [um^2/s]: "))));
        line = fgetl(fd);
    end
    if(contains(line,"Calculated Amounts:"))
        parameters.weights{exp_count} = str2double(strip(split(erase(line,"Calculated Amounts: "))));
        for sub = 1:parameters.sub_nums{exp_count}
            parameters.amplitudes{exp_count}(:,sub) = parameters.amplitudes{exp_count}(:,sub).*parameters.weights{exp_count}(sub);
        end
        line = fgetl(fd);
    end
    if(contains(line,"Calculated t0 [s]:"))
        parameters.t0_values{exp_count} = str2double(strip(split(erase(line,"Calculated t0 [s]: "))));
        line = fgetl(fd);
    end
    if(contains(line,"Total Residuum"))
        exp_count = exp_count+1;
    end
    if(contains(line,"ADEP-FRAP Evaluation Log"))
        parameters = create_profiles(parameters);
        return;
    end
    line = fgetl(fd);
end
fclose(fd);
parameters = create_profiles(parameters);
end