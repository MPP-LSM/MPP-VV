function mms_th_plot_error(xx, comp_soln, manu_soln, ...
    save_plot, plot_filename)
% MMS_TH_PLOT_ERROR(xx, comp_soln, manu_soln, save_plot, exec_name)
% Makes plot of error between computed and manufactured solution for the
% MMS TH problem
% 
% Input arguments:
%   xx            - Grid in x-direction
%   comp_soln     - Computed solution
%   manu_soln     - Manufactured solution
%   save_plot     - 1 = Save plot as PDF 
%   plot_filename - Filename for the plot

figure;
subplot(2,1,1)
jj=1;n=length(comp_soln)/2;
ibeg=(jj-1)*n+1;iend=ibeg+n-1;
plot(xx,comp_soln(ibeg:iend)-manu_soln(ibeg:iend),'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
title('(a) Error in P ')
set(gca,'xticklabel',{''})
ylabel('[Pa]')

subplot(2,1,2)
jj=2;
n=length(comp_soln)/2;
ibeg=(jj-1)*n+1;iend=ibeg+n-1;
plot(xx,comp_soln(ibeg:iend)-manu_soln(ibeg:iend),'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
title('(b) Error in T')
ylabel('[K]')
xlabel('X [m]')

if (save_plot)
    orient landscape
    print('-dpdf', plot_filename,'-fillpage')
end
