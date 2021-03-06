function [diff_coeff,o_sig,o_amps,o_weigth,o_t0,o_dimens,res] = diff_fit(x,y,times,skip_samples,first_s,first_a,amp_dev,dimension,sub_num,init_p0)
% input: sub_num - amount of expected substances, y - profile, x - grid_v,
% times - timestamps, skip_samples - number of first samples to skip,
% first_s - first sigma value, first_a - first amplitude, amp_dev -
% quotient between first two amps, init_p0 - prognosed diff_coeff,
% dimension - diffusion dimension
% output: diff_coeff - diffusion coefficient, o_sig - calculated sigma
% values, o_amps - calculated amplitude values, o_t0 - extraploated t0,
% o_dimens - diffusion dimensionality

global profile
global grid_v
global timestamps
global skip
global first_sigma
global first_amp
global amp_coef
global diff_dim

profile = y;
grid_v = x;
timestamps = times;
skip = skip_samples;
first_sigma = first_s;
first_amp = first_a;
amp_coef = amp_dev;
diff_dim = dimension;
n = length(grid_v);


global f_sig
global f_amps
global f_weigth
global f_t0
global f_dimens
% initialize variables
f_sig=zeros(n,sub_num);
f_amps=zeros(n,sub_num);
f_weigth = zeros(sub_num,1);
f_t0 = zeros(sub_num,1);
f_dimens = ones(sub_num,1)*2;
% use downhill simplex search to determine minimum of the function
diff_coeff = fminsearch(@eval,init_p0);
% transfer output parameters from method intern parameters
o_sig=f_sig;
o_amps=f_amps;
o_weigth = f_weigth;
o_t0 = f_t0;
o_dimens = f_dimens;
res = eval(diff_coeff);
end

% this method evaluates distance from model to dataset by least squares
function result = eval(p)
% fetch global parameters for method evaluation
global profile
global grid_v
global timestamps
global skip
global first_sigma
global first_amp
global amp_coef
global diff_dim
result = 0;
n=length(profile);
global f_sig
global f_amps
global f_weigth
global f_t0
global f_dimens
for sub=1:length(p)
    % extrapolate t0 for each substance for fixed sigma^2 value
    f_t0(sub) = calc_t0(2*p(sub),first_sigma(sub)^2);
    % amp_coef 
    if(amp_coef ~= 0)
    % if diff_dim == 0 the dimensionality of the diffusion is not given
        if(diff_dim == 0)
            f_dimens(sub) = log(amp_coef(sub))/(log(-f_t0(sub))-log(timestamps(2)-f_t0(sub)));
        else
            f_dimens(sub) = diff_dim;
        end
    else
        f_dimens(sub) = diff_dim;
    end
end
% overlay sub_n gausses and calculate distance from values in dataset
for i=1:n
    gauss = 0;
    for sub=1:length(p)
        f_sig(i,sub)=sqrt(2*p(sub)*(timestamps(i)-f_t0(sub)));
        f_amps(i,sub)=1/(sqrt(4*pi*p(sub)*(timestamps(i)-f_t0(sub)))^f_dimens(sub));
        f_weigth(sub) = first_amp(sub)*sqrt(4*pi*p(sub)*(-f_t0(sub)))^f_dimens(sub);
        gauss = gauss + f_weigth(sub)*f_amps(i,sub)*exp(-([grid_v{i}(skip:end)]).^2./((f_sig(i,sub)^2)*2));
    end
    result = result + sum(([profile{i}(skip:end)]-gauss).^2);
end
end
