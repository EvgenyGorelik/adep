function center = circular_detection_v2(img)
%determines center by determining center of values close to image half
%height
%input: img - image containing gaussian distribution
%output: center - determined center

% overlay x and y discrete profiles
x_int = sum(img,1);
y_int = transpose(sum(img,2));
total_int = x_int+y_int;
% get evaluation level, so at least half the amplitude is above is under
% the evaluation height
eval_perc = (min(total_int)/max(total_int)+1)/2;

% get maximally 10 values above and under eval_height and determine their
% center by minimizing least square distance to each point
eval_rad=min(max(max(img))*(1-eval_perc)-1,10);
eval_height=max(max(img))*eval_perc;
eval_height_ind=find(abs(eval_height(1)-img)<=eval_rad);
[x,y] = ind2sub(size(img),eval_height_ind);
func=@(p)sum(sum((p(1)-x).^2+(p(2)-y).^2));
center = [mean(x) mean(y)];
p0 = [center(1) center(2)];
center=fminsearch(func,p0);
end
