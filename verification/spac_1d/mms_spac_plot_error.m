function mms_spac_plot_error(X, dx, nx, computed_solution, manufactured_solution, ...
    save_plots, plot_filename)
% MMS_SPAC_PLOT_ERROR(xx, computed_solution, true_solution, save_plot, plot_filename)
% Makes the plot of error between computed and manufactured solution for
% the MMS Soil-Plant continuum problem
% 
% Input arguments:
%   X                     - Extend of domain in x-direction
%   dx                    - Grid spacing in x-direction
%   nx                    - Number of grid points in x-direction
%   computed_solution     - Computed solution
%   manufactured_solution - Manufactured solution
%   save_plot             - 1 = Save plot as PDF 
%   plot_filename         - Filename for the plot

figure;
ibeg = 1; iend = nx; xx = [-X+dx/2:dx:0];
plot(computed_solution(ibeg:iend)-manufactured_solution(ibeg:iend),xx,'-','linewidth',2)
hold all

ibeg = 1+nx; iend = nx*2;  xx = [-X+dx/2:dx:0];
plot(computed_solution(ibeg:iend)-manufactured_solution(ibeg:iend),xx,'-','linewidth',2)

ibeg = 1+nx*2; iend = nx*4;  xx = [dx/2:dx:X*2];
plot(computed_solution(ibeg:iend)-manufactured_solution(ibeg:iend),xx,'-','linewidth',2)

set(gca,'fontweight','bold','fontsize',14)
grid on
legend('\DeltaP^{Soil}','\Delta P^{Root}','\Delta P^{Xylem}')
title('Error in pressure')
xlabel('[Pa]')
ylabel('Z [m]')
if (save_plots)
    orient landscape
    print('-dpdf', plot_filename,'-fillpage')
end
