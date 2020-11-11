function [p0,itsum] = powel_method_v1(x,y,n,prec)
%x is grid,y is given values, n substance amount ,prec defines the
%desired precision
%output: parameter vector for n substances
%dynamic stepsize for iteration step reduction and gaining precision

global subst
global x_coor
global y_coor
global counter
counter=0;
subst=n;
x_coor=x;
y_coor=y;

% profile amplitude and variance for p0 initialization
amplitude = max(y);
variance = calc_variance_1D(y);
% p0 initial parameter guess
p0 = zeros(2*n,1);
for i=1:n
    p0(2*i-1) = amplitude/n;
    p0(2*i)= variance;
end
val=0;
for i=1:n
    val = val+p0(2*i-1)*exp(-x.^2./(2*p0(2*i)^2));
end
residual = eval(p0);
old_residual = residual*2;
%iteration counters
iter = 0;
ITMAX = 200;
STEPMAX = 3000;
%iterate until results don't get better
while(old_residual>residual && iter<ITMAX)
    %take best value in each parameter direction
    for i=1:2*n
        p_up = p0;
        p_down = p0;
        p_up(i) = p0(i)+prec;
        p_down(i) = p0(i)-prec;
        %choose direction, in which to minimize
        if(eval(p_up)<eval(p_down))
            local_iter=0;
            bracket_a = p_up(i);
            bracket_b = p_up(i)^2;
            p_down = p_up;
            %minimize until no longer possible
            while((abs(bracket_a-bracket_b) > prec) && local_iter<STEPMAX)
                mid_p = (bracket_a+bracket_b)/2;
                p_up(i) = mid_p+prec;
                p_down(i) = mid_p-prec;
                if(eval(p_up)<eval(p_down))
                    bracket_a = mid_p+prec;
                else 
                    bracket_b = mid_p-prec;
                end
                local_iter=local_iter+1;
            end
            p0(i)=mid_p;
            %after iteration p0(i) has last minimal value
        else
            local_iter=0;
            bracket_a = 0;
            bracket_b = p_down(i);
            p_up = p_down;
            %minimize until no longer possible
            while((abs(bracket_a-bracket_b) > prec) && local_iter<STEPMAX)
                mid_p = (bracket_a+bracket_b)/2;
                p_up(i) = mid_p+prec;
                p_down(i) = mid_p-prec;
                if(eval(p_up)<eval(p_down))
                    bracket_a = mid_p+prec;
                else 
                    bracket_b = mid_p-prec;
                end
                local_iter=local_iter+1;
            end
            p0(i)=mid_p;
        end
    end
    old_residual = residual;
    residual = eval(p0);
    iter = iter + 1;
end
itsum=counter;
end

% evaluation function shows current residual for given parameters
function fun_val = eval(p)
global subst
global x_coor
global y_coor
global counter
counter = counter + 1;
val=0;
for i=1:subst
    val = val+p(2*i-1)*exp(-x_coor.^2./(2*p(2*i)^2));
end
% squared difference of model values to data values
fun_val = sum((val-y_coor).^2);
end
