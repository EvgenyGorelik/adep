function amplitude_t_plot(parameters, app, exp_num)
cla(app.AmplitudePlot)
for i=1:parameters.sub_nums{exp_num}
    grid_v = log(parameters.timestamps{exp_num}-parameters.t0_values{exp_num}(i));
    values = log(parameters.amplitudes{exp_num}(:,i));
    plot(app.AmplitudePlot,grid_v,values,'*');
    hold(app.AmplitudePlot,'on')
    [values,~,~]= elr(values,grid_v);
    plot(app.AmplitudePlot,grid_v,values);
end
axis(app.AmplitudePlot,'tight');
end

