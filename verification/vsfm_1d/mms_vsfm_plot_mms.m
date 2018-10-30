function mms_vsfm_plot_mms(xx,manu_soln,perm,sat,source,save_plots,plot_filename)
% MMS_VSFM_PLOT_MMS(xx,manu_soln,perm,sat,source,save_plots,plot_filename)
% Make the manu manufactured solutions of the MMS VSFM problem
%
%  xx            - Grid in x-direction
%  manu_soln     - Manufacture solution of pressure
%  perm          - Manufactured solution of soil permeability
%  sat           - Liquid saturation corresponding to manufactured solutions
%  source        - Source term corresponding to manufactured solutions
%  save_plot     - 1 = Save plot as PDF 
%  plot_filename - Filename for the plot

figure;
subplot(4,1,1)
plot(xx,manu_soln,'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
set(gca,'xticklabel',{})
ylabel('[Pa]')
title('(a) Manufactured solution of pressure')

subplot(4,1,2)
plot(xx,perm,'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
set(gca,'xticklabel',{})
ylabel('[m^2]')
title('(b) Manufactured solution of permeability')

subplot(4,1,3)
plot(xx,sat,'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
ylabel('[-]')
title('(c) Analytical estimate of saturation')

subplot(4,1,4)
plot(xx,source,'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
ylabel('[kg s^{-1}]')
title('(d) Analytical estimate of source term')
xlabel('X [m]')

if (save_plots)
    orient landscape
    print('-dpdf', plot_filename,'-fillpage')
end