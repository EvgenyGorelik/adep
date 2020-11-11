function [result,residual] = profile_fit_v2(x,y,times,n)
% input: x - grid vector, y - values, times - timestamps of the images, n number of substances
% output: result - amp/sig vector, residual - residual value
global subst
global x_coor
global y_coor
global t
subst=n;
x_coor=x;
y_coor=y;
t=times;

% profile amplitude and variance for p0 initialization
amplitude = [max([y{1}]) max([y{2}])];
variance = [calc_variance_1D([y{1}]) calc_variance_1D([y{2}])];
if(abs(variance(2)-variance(1))<10^-3)
    variance(2) = variance(2)+0.5;
end
if(variance(2)<variance(1))
    variance(2) = variance(1)+0.5;
end
% p0 initial parameter guess
p0 = zeros(4*n,1);
for i=1:n
    p0(2*i-1) = amplitude(1)/n;
    p0(2*i)= variance(1);
end
for i=n+1:2*n
    p0(2*i-1) = amplitude(2)/n;
    p0(2*i)= variance(2);
end
% minimize model to value distance 
options = optimset('MaxFunEvals',500*length(p0));
result=fminsearch(@eval,p0,options);
residual = eval(result);
end

% calculate current parameter set for first two images and compare to
% prediction values of the remaining images
function fun_val = eval(p)
global subst
global x_coor
global y_coor
global t
sample_num = length(x_coor);
sig_vals = zeros(subst,2);
amp_vals = zeros(subst,2);
fun_val=0;
% every second entry in p starting from 2 are sigma values of the first
% image
sig_vals(:,1) = p(2:2:2*subst);
% every second entry in p starting from 1 are amplitude values of the first
% image
amp_vals(:,1) = p(1:2:2*subst);
% sort sigma values by asscending order
[sig_vals(:,1),sub_assign] = sort(sig_vals(:,1),1);
% sort corresponding amplitude values by index
amp_vals(:,1) = switch_by_ind(sub_assign,amp_vals(:,1));
% transfer according values from the second image
sig_vals(:,2) = p(2*subst+2:2:4*subst);
amp_vals(:,2) = p(2*subst+1:2:4*subst);
% sort sigma values from second image
[sig_vals(:,2),sub_assign] = sort(sig_vals(:,2),1);
amp_vals(:,2) = switch_by_ind(sub_assign,amp_vals(:,2));
for sample = 1:2
    val=0;
    for i=1:subst
        % calculate model profile
        val = val+amp_vals(i,sample)*exp(-[x_coor{sample}].^2./(2*sig_vals(i,sample)^2));
    end
    % least squares of model values to actual values
    fun_val = fun_val + sum((val-[y_coor{sample}]).^2);
end
diff_coef = zeros(subst,1);
t0 = zeros(subst,1);
% based on current amp and sigma values calculate diffustion coefficient
% and values for remaining profiles and compare to data values
for i=1:subst
    diff_coef(i) = (sig_vals(i,2)^2-sig_vals(i,1)^2)/(t(2)-t(1))/2;
    t0(i) = -(sig_vals(i,1)^2-2*diff_coef(i)*t(1))/(2*diff_coef(i));
end
for sample = 3:sample_num
    val=0;
    for i=1:subst
        ex_sig = sqrt(diff_coef(i)*2*(t(sample)-t(1))+sig_vals(i,1)^2);
        ex_amp = (amp_vals(i,1)*4*pi*diff_coef(i)*(t(1)-t0(i)))/(4*pi*diff_coef(i)*(t(sample)-t0(i)));
        val = val + ex_amp*exp(-[x_coor{sample}].^2./(2*ex_sig^2));
    end
    fun_val = fun_val + sum((val-[y_coor{sample}]).^2);
end

end

function rot_amps = switch_by_ind(ind, amps)
[sub_amount] = length(amps);
rot_amps = zeros(sub_amount,1);
for sub = 1:sub_amount
    rot_amps(sub) = amps(ind(sub,:));
end
end
