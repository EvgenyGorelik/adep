function variance = calc_variance_1D(vector)
%input: gaussian distributet vector and it's center
%output: variance value

%calculate amplitude first
[amplitude,center] = max(double(vector));

[~,var_index] = min(abs(vector-amplitude/2));
variance = abs(center-var_index)/sqrt(2*log(2));

end

