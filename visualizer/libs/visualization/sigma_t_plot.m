function sigma_t_plot(parameters, app, exp_num)
cla(app.SigmaPlot)
for i=1:parameters.sub_nums{exp_num}
    grid_v = parameters.timestamps{exp_num}-parameters.t0_values{exp_num}(i);
    values = (parameters.sigmas{exp_num}(:,i)/parameters.voxel_size{exp_num}).^2;
    plot(app.SigmaPlot,grid_v,values,'*');
    hold(app.SigmaPlot,'on')
    [values,~,~]= elr(values,grid_v);
    plot(app.SigmaPlot,grid_v,values);
end
axis(app.SigmaPlot,'tight');
end

