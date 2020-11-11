function [sub_num,sub_count] = n_sub_prof(grid_v,profiles, sample_num, thresh)
% input: image_stack - image data, sample_num - number of randomly chosen
% images, thresh - threshold for two similar sigmas
% output: sub_num - highest occuring number of substances
im_num = length(profiles);
im_sel = 1 + uint8(rand(sample_num,1)*(im_num - 1));
sample_prof = profiles(im_sel);
sample_grid = grid_v(im_sel);
im_sub = zeros(size(sample_prof,3));
% for each image determine number of maximal substances differing by at
% least thresh percent from each other
for i = 1:sample_num
    im_sub(i) = max_sub([sample_grid{i}],[sample_prof{i}], thresh);
end
sub_count = zeros(10,1);
% calculate the mostly occuring substance amount
for i = 1:sample_num
    sub_count(im_sub(i)) = sub_count(im_sub(i)) + 1;
end
[~,sub_num] = max(sub_count);
end

% function determines the number of substances 
% for current image
function sub_num = max_sub(grid_v, profile, thresh)
    for sub_num = 1:8
        p = powel_method_v1(grid_v, profile, sub_num, 10^-5);
        sig = p(2:2:end);
        if(is_sim(sig, thresh) == 1)
            sub_num = sub_num - 1;
            return;
        end
    end
end

% function checks if sigma vector 
% contains similar entries
function sim = is_sim(sig, thresh)
    if(min(sig) < thresh)
        sim = 1;
        return
    end
    if(max(sig)/100 > thresh)
        sim = 1;
        return
    end
    for i = 1:length(sig)
        for j = i+1:length(sig)
            if(min([sig(i),sig(j)])/max([sig(i),sig(j)]) >= thresh)
                sim = 1;
                return;
            end
        end
    end
    sim = 0;
end