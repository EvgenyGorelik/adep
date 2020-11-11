function [result,total_iter] = profile_fit(x,y,n)
% input: x - grid for given values, y - given values, n - number of
% substances
% output: result - amplitude and sigma values, total_iter - number of
% iterations

global subst
global x_coor
global y_coor
subst=n;
x_coor=x;
y_coor=y;

global iter
iter=0;

% profile amplitude and variance for p0 initialization
amplitude = max(y);
variance = calc_variance_1D(y);
% p0 initial parameter guess
p0 = zeros(2*n,1);
for i=1:n
    p0(2*i-1) = amplitude/n;
    p0(2*i)= variance;
end
options = optimset('MaxFunEvals',500*length(p0));
% minimize least sqaures for amplitude and sigma parameters
result=fminsearch(@eval,p0,options);
total_iter=iter;
end

function fun_val = eval(p)
global subst
global x_coor
global y_coor
global iter
iter = iter + 1;
val=0;
for i=1:subst
    val = val+p(2*i-1)*exp(-x_coor.^2./(2*p(2*i)^2));
end
fun_val = sum((val-y_coor).^2);
end

