function path = find_files(folder, name, extension)
% input: path - path to files, name - string contained in file name,
% extension - file type of the file
% output: image_path - all paths containing name string and extension file
% type
dirs = dir(folder);
path = 0;
num = count([dirs.name],name);
if(num > 0)
    path = strings(num,1);
    my_index = 1;
    for i = 3:length(dirs)
        cur_name = dirs(i).name;
        cur_ext = split(cur_name,'.');
        if(contains(cur_name,name) && strcmpi(cur_ext(end),extension)) 
            path(my_index) = string(dirs(i).folder) + "\" + cur_name;
            my_index = my_index + 1;
        end
    end
    if(my_index < num)
        path = path(1:my_index-1);
    end
end
end

