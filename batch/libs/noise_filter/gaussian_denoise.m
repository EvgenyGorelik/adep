function image = gaussian_denoise(image,sigma,filter_size)
% input: image - data matrix, sigma - gaussian sigma value, filter_size -
% gaussian box size
% output: image - gaussian filtered image
image=imgaussfilt(image,sigma,'FilterSize',[filter_size filter_size]);
end

