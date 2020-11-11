function [profile,grid] = distributed_profile(matrix,center,threshold)
% input: matrix - gaussian distributed data matrix, center - distribution
% center, treshold
% output: profile - value vector, grid - underlying grid

% optional default value for threshold
if isempty('threshold') || ~exist('threshold','var')
    threshold_val=20;
else
    threshold_val=threshold;
end
% determine matrix size and the minimal distance from the center to an edge
[w,h] = size(matrix);
min_dist = round(min([center(1) w-center(1) center(2) h-center(2)]));
% initialize the vectors
values = zeros(min_dist^2,1);
dist = zeros(min_dist^2,1);
dist_hist = zeros(min_dist,1);
count=1;
for i=1:h
    for j=1:w
        d=norm([i,j]-center);
        % check weather the index coorinate is in min_dist range from the
        % center
        if(d<min_dist)
            % store its distance and its value
            dist(count)=d;
            values(count)=matrix(i,j);
            % increase the amount of points in the bin
            dist_hist(floor(d)+1)=dist_hist(floor(d)+1)+1;
            count=count+1;
        end
    end
end
% sort the values in dist and apply the re-indexing to the values
[sortedKeys, sortedIndices] = sort(dist);
sortedValues = values(sortedIndices);
% determine the first bin containing at least threshold values
threshold_dist=length(find(dist_hist<=threshold_val));
% determine the amount of values
threshold_count=sum(dist_hist(1:threshold_dist));
% initialize the values and vectors
grid_length = threshold_count + min_dist - threshold_dist;
profile=zeros(grid_length,1);
grid=zeros(grid_length,1);
% store the first threshold_count values in the vectors
grid(1:threshold_count)=sortedKeys(1:threshold_count);
profile(1:threshold_count)=sortedValues(1:threshold_count);
if(threshold_count == 0)
   threshold_dist = 1;
   threshold_count = 1;
end
for i=threshold_dist:min_dist
    % find indexes within the boundries and calculate the average of their
    % values
    bound_a=length(find(abs(sortedKeys<i)));
    bound_b=length(find(abs(sortedKeys<i+1)));
    val_avg=mean(sortedValues(bound_a:bound_b));
    key_avg=mean(sortedKeys(bound_a:bound_b));
    profile(threshold_count+i-threshold_dist)=val_avg;
    grid(threshold_count+i-threshold_dist)=key_avg;
end
if(bound_a == bound_b)
    profile(end) = profile(end-1);
end
end

