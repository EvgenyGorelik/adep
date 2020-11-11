function [valid_matrix] = calc_valid_matrix(sigmas)
% DEPRICATED
% input: sigmas - calculateds sigma values
% output: valid_matrix - contains valid or not valid bit for every sigma
% value
[sort_sig, ~] = sort(sigmas,2);
[sample_amount,sub_amount]=size(sigmas);
% initial all sigmas are valid
valid_matrix = ones(sample_amount,sub_amount);
for sub=1:sub_amount
    for sample=0:sample_amount-1
        pos = mod(start_pos + sample,sample_amount) + 1;
        if(sort_sig(pos,sub) <= 0)
            valid_matrix(pos,sub) = 0;
        else
            last_valid = find_last_valid(valid_matrix(:,sub),pos);
            compare = [sort_sig(pos,sub),sort_sig(last_valid,sub)];
            if(min(compare)/max(compare)<=accept_thresh)
                valid_matrix(pos,sub) = 0;
            end
        end
    end
end
end

