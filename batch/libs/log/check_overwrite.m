function filename = check_overwrite(filename)
% input: filename - name of file with folder
% output: filename - filename followed by a unique number 
filename = erase(filename,".log");
split_name = split(filename,"_");
if(strcmp(split_name,filename))
    filename = filename+".log";
    return
end
current_num = str2num(split_name{end});
if(~isempty(current_num))
    filename=erase(filename,"_"+split_name{end});
    i = current_num+1;
else
    i = 1;
end
filenum = sprintf('%03d',i);
filename = filename + "_" + filenum + ".log";
while (isfile(filename))
    i = i + 1;
    filenum = sprintf('%03d',i);
    filename = erase(filename,".log");
    filename = erase(filename,"_" + sprintf('%03d',i-1));
    filename = filename + "_" + filenum + ".log";
end
end

