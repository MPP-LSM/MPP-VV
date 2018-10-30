function mms_thermal_plot_error(x, y, z, computed_solution, manufactured_solution, ...
    save_plot, plot_filename)
% MMS_THERMAL_PLOT_ERROR(xx, computed_solution, manufactured_solution, save_plot, exec_name)
% Makes the plot of error between computed and manufactured solution 
% for the MMS thermal problem
% 
%  xx                    - Grid in x-direction
%  computed_solution     - Computed solution
%  manufactured_solution - Manufactured solution
%  save_plot             - 1 = Save plot as PDF 
%  plot_filename         - Filename for the plot

nn = length(x);

figure;
slice(x,y,z,reshape(manufactured_solution-computed_solution,nn,nn,nn),[.25 .75], .50, [.25 .75]);
colormap jet
set(gca,'fontweight','bold','fontsize',18)
h = colorbar;
title(h,'[K]')
xlabel('[m]')
ylabel('[m]')
zlabel('[m]')
caxis([-0.04 0.04])
gca_pos = get(gca,'Position');
hp = get(h,'Position');hp(1)=0.88;set(h,'Position',hp);
set(gca,'Position',gca_pos)
th=title(sprintf('Error in temperature'));
if (save_plot)
    orient landscape
    print('-dpdf', plot_filename, '-fillpage')
end

