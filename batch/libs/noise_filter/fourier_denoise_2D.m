function denoise = fourier_denoise_2D(values,cut_treshold)
% input: values as an matrix and treshold from which on high frequencies will be cut off 
% output denoised values, with frequencys over treshold cut off

% transform to fourier
Y = fftshift(fft2(values));
[width,height] = size(Y);
% create grid for the filter
[x_coor,y_coor] = meshgrid(-width/2:width/2-1,-height/2:height/2-1);
% filter values greater than treshold radius
filter = ((x_coor).^2 + (y_coor).^2 <= cut_treshold^2);
% reverse transformation of filtered values
denoise = ifft2(ifftshift(Y.*filter));
end