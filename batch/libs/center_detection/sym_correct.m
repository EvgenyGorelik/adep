function center = sym_correct(image,center,windowsize)
% input: image - gaussian distributed matrix, center - approximate center
% coordinates, windowsize - size of the region that is scoped
% output: center - corrected center coordinates

% initialize optional parameters
if isempty('center') || ~exist('center','var')
    center=size(image)/2;
end
if isempty('windowsize') || ~exist('windowsize','var')
    windowsize=10;
end
% global variables needed for evaluation
global matrix
global w_size
global fact
matrix=image;
fact=0.1;
w_size=windowsize;
% find point that is most invariant to rotation
center=fminsearch(@eval,center);
end
% eval function for numerical evaluation
function fun_val = eval(center)
global matrix
global w_size
global fact
% extract values in a window around center
window = matrix(round(center(1))-w_size:round(center(1))+w_size,round(center(2))-w_size:round(center(2))+w_size);
[X,Y] = meshgrid(center(1)-w_size:center(1)+w_size,center(2)-w_size:center(2)+w_size);
[Xq,Yq] = meshgrid(center(1)-w_size:fact:center(1)+w_size,center(2)-w_size:fact:center(2)+w_size);
% interpolate with the finer grid
window_p=interp2(X,Y,window,Xq,Yq);
fun_val=sum(sum((window_p-rot90(window_p)).^2));
end