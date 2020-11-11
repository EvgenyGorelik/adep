function leica_file = get_leica(image_file)
% input: image_file - path to image from series
% output: leica_file - path to leica file in folder
set = split(image_file,'\');
leica_file = strjoin(set(1:end-1),'\')+"\"+set(end-1)+".txt";
end

