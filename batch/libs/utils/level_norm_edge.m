function zero_level = level_norm_edge(img,row_num)
% input: img - gaussian distributed matrix, row_num - number of rows
% included for average calculation
% output: zero_level - average of all pixels on the edge of the image up to
% row_num
zero_level = mean([mean(img(1:row_num,:)) mean(img(end-row_num:end,:)) mean(img(:,1:row_num)) mean(img(end-row_num:end,:))]);
end

