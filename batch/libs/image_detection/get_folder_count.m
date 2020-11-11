function [count,folders] = get_folder_count(parent)
% input: parent - name of parent directory
% output: count - number of folders, subFolders - cell array with folder
% names
dirs = regexp(genpath(parent),['[^;]*'],'match');
folders = dirs(1:end);
count = length(folders);
end

