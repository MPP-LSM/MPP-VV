function mms_th_plot_mms(xx,manu_soln,perm,source,save_plot,plot_filename)
% MMS_TH_PLOT_MMS(xx,manu_soln,perm,source,save_plots,plot_filename)
% Makes plot of manufactured for the MMS TH problem.
%
% Input arguments:
%   xx            - Grid in x-direction
%   manu_soln     - Manufacture solution of pressure
%   perm          - Manufactured solution of soil permeability
%   source        - Source term corresponding to manufactured solutions
%   save_plot     - 1 = Save plot as PDF 
%   plot_filename - Filename for the plot

figure;clf
subplot(5,1,1)
jj=1;n=length(manu_soln)/2;
ibeg=(jj-1)*n+1;
iend=ibeg+n-1;
plot(xx,manu_soln(ibeg:iend),'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
title('(a) Manufactured solution of pressure')
ylabel('[Pa]')
set(gca,'xticklabel',{''})

subplot(5,1,2)
jj=2;n=length(manu_soln)/2;
ibeg=(jj-1)*n+1;
iend=ibeg+n-1;
plot(xx,manu_soln(ibeg:iend),'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
title('(b) Manufactured solution of temperature')
ylabel('[K]')
ylim([290 300])
set(gca,'xticklabel',{''})

subplot(5,1,3)
jj=1;n=length(manu_soln)/2;
ibeg=(jj-1)*n+1;iend=ibeg+n-1;
plot(xx,perm(ibeg:iend),'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
title('(c) Manufactured solution of permeability')
ylabel('[kg s^{-1}]')
set(gca,'xticklabel',{''})

subplot(5,1,4)
jj=1;n=length(source)/2;
ibeg=(jj-1)*n+1;iend=ibeg+n-1;
plot(xx,source(ibeg:iend),'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
title('(d) Analytical source term for Pressure')
ylabel('[kg s^{-1}]')
set(gca,'xticklabel',{''})

subplot(5,1,5)
jj=2;n=length(source)/2;
ibeg=(jj-1)*n+1;iend=ibeg+n-1;
plot(xx,source(ibeg:iend),'-','linewidth',2)
set(gca,'fontweight','bold','fontsize',14)
grid on
title('(e) Analytical source term for Temperature')
ylabel('[J s^{-1}]')
xlabel('X [m]')

if (save_plot)
    orient landscape
    print('-dpdf', plot_filename,'-fillpage')
end
