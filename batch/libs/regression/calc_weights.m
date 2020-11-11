function weights = calc_weights(num,mode,fac)
% input: num - number of required weights, mode - mode of weight
% assignement, fac - methodspecific factor
% output: weights - calculated weights 
weights = ones(num,1);
x = 0:num-1;
if(strcmp(mode,"Linear"))
    for i = 1:num
        weights = max(1-x*fac,0);
    end
end
if(strcmp(mode,"Sqrt"))
    for i = 1:num
        weights = max(1-sqrt(x)*fac,0);
    end
end
if(strcmp(mode,"Quad"))
    for i = 1:num
        weights = max(1-x.^2*fac,0);
    end
end
if(strcmp(mode,"Exp"))
    for i = 1:num
        weights = max(1-exp(x)*fac,0);
    end
end
end

