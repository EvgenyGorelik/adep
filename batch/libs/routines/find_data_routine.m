function [img_paths, bckg_paths, leica_paths] = find_data_routine(parent_dir, bckg_name, img_name, image_type, leica_name, leica_type)
% input: parent_dir - parent folder, bckg_name - unique background image
% string, img_name - unique image string, image_type - image format,
% leica_name - unique leica string
% output: imp_paths - paths to images, bckg_paths - paths to backgrounds,
% leica_paths - paths to leica data
[folder_count,folder_paths] = get_folder_count(parent_dir);
bckg_paths = cell(folder_count,1);
img_paths = cell(folder_count,1);
leica_path_cells = cell(folder_count,1);
% iterate trough detected folders
for i = 1:folder_count
    % get images in folder
    img_paths{i} = find_files(folder_paths{i}, img_name, image_type);
    % if folder is not found set cell to empty
    if(isnumeric(img_paths{i}))
        img_paths{i} = {};
        bckg_paths{i} = {};
        leica_path_cells{i} = {};
    else
        % if folder contains no images assign empty cell
        if(isempty(img_paths{i}))
            img_paths{i} = {};
            bckg_paths{i} = {};
            leica_path_cells{i} = {};
        else
            % set background and images and leica paths if found
            bckg_paths{i} = find_files(folder_paths{i}, bckg_name, image_type);
            leica_path_cells{i} = find_files(folder_paths{i}, leica_name, leica_type);
            % if leica path is empty get the path of the first image
            if(isnumeric(leica_path_cells{i}))
                leica_path_cells{i} = get_leica(img_paths{i}(1));
            end
        end
    end
end
% delete empty cells
bckg_paths = bckg_paths(~cellfun('isempty',bckg_paths));
img_paths = img_paths(~cellfun('isempty',img_paths));
leica_path_cells = leica_path_cells(~cellfun('isempty',leica_path_cells));
leica_paths = string(leica_path_cells);
