function distrib_plot(parameters, app, exp_num)
cla(app.DistributionPlot)
weight_sum = sum(parameters.weights{exp_num});
bar(app.DistributionPlot,parameters.diff_coefs{exp_num},parameters.weights{exp_num}/weight_sum,0.1);
end

