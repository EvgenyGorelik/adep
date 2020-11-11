function result = calc_diffusion(sigma_vals,time_vals)
% input: sigma_vals - sigma values, time_vals - according timestamps
% output: result - diffusion coefficient for given values
[~,m,~] = elr(sigma_vals(:).^2,time_vals());
result = m/2;
end

