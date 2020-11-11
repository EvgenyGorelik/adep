function log_matrix(matrix, height, path)
% inuput: message - output text, path - file path
fd = fopen(path, 'a');
for i = 1:height
    fprintf(fd,'%12.8f\t',matrix(i,:));
    fprintf(fd,'\n');
end
fclose(fd);
end

