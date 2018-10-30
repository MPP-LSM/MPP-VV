function mms_vsfm_plot_error(xx, computed_solution, manufactured_solution, ...
    save_plot, plot_filename)
% MMS_VSFM_PLOT_ERROR(xx, computed_solution, manufactured_solution, save_plot, plot_filename)
% Makes the plot of error between computed and manufactured solution for
% the MMS VSFM problem
% 
% Input arguments:
%   xx                    - Grid in x-direction
%   computed_solution     - Computed solution
%   manufactured_solution - Manufactured solution
%   save_plot             - 1 = Save plot as PDF 
%   plot_filename         - Filename for the plot

figure;
plot(xx,computed_solution - manufactured_solution,'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
xlabel('X [m]')
ylabel('[Pa]')
title('Error in pressure')
if (save_plot)
    orient landscape
    print('-dpdf', plot_filename,'-fillpage')
end
