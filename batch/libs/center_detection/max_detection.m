function center = max_detection(image)
%input: image for detection
%output: coordinate of point with max value
[max_val] = max(max(image));
[x,y]= find(abs(image-max_val)<10^-10);
center = [x(1) y(1)];
end

