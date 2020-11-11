function sub_num = n_sub_prof_det(grid_v, profile, thresh)
% input: image_stack - image data, sample_num - number of randomly chosen
% images, thresh - threshold for two similar sigmas
% output: sub_num - highest occuring number of substances

% performs search of maximum substances for one sample
sub_num = max_sub(grid_v, profile, thresh);
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