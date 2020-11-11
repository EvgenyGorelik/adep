function total_sum = total_res(imgs,sig,amps,centers)
% input: imgs - all images, sig - calculated sigma values, amps -
% calculated amplitude values, centers - determined center coordinates
% output: total_sum - sum of error squared
[w,h,n] = size(imgs);
total_sum = 0;
for i =1:n
    total_sum = total_sum + sum(sum((imgs(:,:,i)-multigauss_uncentred(sig(i,:),amps(i,:),centers(i,:),w,h)).^2));
end
end

