function [sub_num,sub_count] = n_sub(image_stack, sample_num, thresh)
% DEPRICATED
% input: image_stack - image data, sample_num - number of randomly chosen
% images, thresh - threshold for two similar sigmas
% output: sub_num - highest occuring number of substances
[~,~,im_num] = size(image_stack);
im_sel = 1 + uint8(rand(sample_num,1)*(im_num - 1));
samples = image_stack(:,:,im_sel);
im_sub = zeros(size(samples,3));
% for each image determine number of maximal substances differing by at
% least thresh percent from each other
for i = 1:sample_num
    im_sub(i) = max_sub(samples(:,:,i), thresh);
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
function sub_num = max_sub(img, thresh)
    img = imgaussfilt(flip_matrix(img),2);
    center = gaussian_detection(img);
    [profile,grid_v] = distributed_profile(img, center, 5);
    profile = level_norm(profile);
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