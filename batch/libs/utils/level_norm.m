function [profile,zero] = level_norm(profile)
% input: profile - gaussian distributed value vector
% output: profile - normalized profile value, so the distribution converges
% to zero, zero - subtracted amount
[hist_count,hist_binval] = histcounts(profile,round(abs(min(profile)-max(profile))));
[~, max_index] = max(hist_count);
zero = hist_binval(max_index);
profile = profile - zero;
end

