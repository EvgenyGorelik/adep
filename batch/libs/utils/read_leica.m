function [times,voxel] = read_leica(im_num, bck_num, path)
% input: im_num - number of images, bck_num - number of background images
% path - path to leica file
% output: times - vector with timestamps of the images, voxel - actual size
% of a voxel in the image
% if no file is provided, the timestamps are created in unit 1
if(~isfile(path))
    times = transpose(1:im_num);
    voxel = 1;
    return
end
times = zeros(im_num,1);
count = 1;
fd = fopen(path);
line = fgets(fd);
while(line ~= -1)
    if(contains(line,"Stamp_"))
        if(bck_num <= 0)
            time_stamp = strsplit(line,': ');
            times(count) = get_time(time_stamp);
            count = count + 1;
        end
        bck_num = bck_num - 1;
    end
    if(contains(line,"Voxel-Width"))
        voxel = str2double(strip(erase(erase(line,'Voxel-Width'),'[µm]')));
    end
    line = fgets(fd);
end
fclose(fd);
end

function time = get_time(time)
date_time = split(strip(time{2}),[',',":"]);
time = str2double(date_time{7}) + 1000*str2double(date_time{6})...
    + 60*1000*str2double(date_time{5}) + 60*60*1000*str2double(date_time{4})...
    + 24*60*60*1000*str2double(date_time{3});

time = time/1000;
end
