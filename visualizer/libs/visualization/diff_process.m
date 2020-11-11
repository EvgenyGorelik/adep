function diff_process(parameters, app, chosen)
%DIFF_PROCESS Summary of this function goes here
%   Detailed explanation goes here
n = length(parameters.images{chosen});
cla(app.ExperimentAxes)
skip = 1;
if(n > 20)
    skip = round(n/20);
end
for i=1:skip:n
    plot3(app.ExperimentAxes,ones(...
        length([parameters.grid_v{chosen}{i}]),1)*parameters.timestamps{chosen}(i),...
        [parameters.grid_v{chosen}{i}],[parameters.profiles{chosen}{i}],'.');
    profile = multigauss_profile([parameters.sigmas{chosen}(i,:)],[parameters.amplitudes{chosen}(i,:)],[parameters.grid_v{chosen}{i}]*parameters.voxel_size{chosen});
    plot3(app.ExperimentAxes,ones(...
        length([parameters.grid_v{chosen}{i}]),1)*parameters.timestamps{chosen}(i),...
        [parameters.grid_v{chosen}{i}],profile);
    hold(app.ExperimentAxes,'on')
end
grid(app.ExperimentAxes,'on')
axis(app.ExperimentAxes,'tight')
end

