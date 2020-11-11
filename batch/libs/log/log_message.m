function log_message(message, path)
% inuput: message - output text, path - file path
fd = fopen(path, 'a');
fprintf(fd,'%s',message);
fprintf(fd,'\n');
fclose(fd);
end

