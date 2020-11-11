function [amp_vals,sigma_vals,time_vals,valid_matrix] = simple_val_assign(amps,sigmas,timestamps,accept_thresh,start_pos)
% input: amps - fitted amplitude values, sigmas - fitted sigma values,
% timestamps - times of images, accept_thresh - threshold of maximal ratio
% of to successive sigma values, start_pos - first valid sigma value
% output: amp_vals - amplitude values,
if isempty('accept_thresh') || ~exist('accept_thresh','var')
    accept_thresh=0.6;
end
if isempty('start_pos') || ~exist('start_pos','var')
    start_pos=2;
end
% sort each row of sigmas
[sort_sig, sortedIndices] = sort(sigmas,2);
sort_amp = switch_by_ind(sortedIndices,amps);
[sample_amount,sub_amount]=size(sigmas);
% valid_matrix tells if values are included in the computation or if the
% quotient of a value compared to the last valid sigma is lower then
% accept_thresh
% initially all values are allowed
valid_matrix = ones(sample_amount,sub_amount);
for sub=1:sub_amount
    for sample=0:sample_amount-1
        pos = mod(start_pos + sample,sample_amount) + 1;
        if(sort_sig(pos,sub) <= 0)
            valid_matrix(pos,sub) = 0;
        else
            % find last valid value index
            last_valid = find_last_valid(valid_matrix(:,sub),pos);
            compare = [sort_sig(pos,sub),sort_sig(last_valid,sub)];
            % check if current value is acceptible
            if(min(compare)/max(compare)<=accept_thresh)
                valid_matrix(pos,sub) = 0;
            end
        end
    end
end
amp_vals = cell(1,sub_amount);
sigma_vals = cell(1,sub_amount);
time_vals = cell(1,sub_amount);
for sub = 1:sub_amount
    % if the value is in the valid matrix, it is included in the
    % calculation and given to output
    valid = find(valid_matrix(:,sub));
    amp_vals(sub) = {sort_amp(valid,sub)};
    sigma_vals(sub) = {sort_sig(valid,sub)};
    time_vals(sub) = {timestamps(valid)};
end
end

function ret = find_last_valid(valids, pos)
dim = length(valids);
for i = 1:dim
    ret = mod(pos - i - 1 + dim, dim) + 1;
    if(valids(ret) ~= 0)
        break;
    end
end
end

function rot_amps = switch_by_ind(ind, amps)
[sample_amount, sub_amount] = size(amps);
rot_amps = zeros(sample_amount,sub_amount);
for sample = 1:sample_amount
    rot_amps(sample,:) = amps(sample,ind(sample,:));
end
end
