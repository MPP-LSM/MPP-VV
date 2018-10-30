function mms_spac_plot_mms(X, dx, nx, manu_soln, source, liq_sat, rel_perm, ...
    save_plot, plot_filename)
% MMS_SPAC_PLOT_MMS(X, dx, nx, manu_soln, source, save_plot, plot_filename)
% Makes plot of manufactured solution for the MMS Soil-Plant continuum problem.
%
% Input arguments:
%   X             - Extend of domain in x-direction
%   dx            - Grid spacing in x-direction
%   nx            - Number of grid points in x-direction
%   manu_soln     - Manufactured solution
%   source        - Source term corresponding to manufactured solutions
%   save_plot     - 1 = Save plot as PDF 
%   plot_filename - Filename for the plot

figure;
subplot(2,3,1:3);
ibeg = 1; iend = nx; xx = [-X+dx/2:dx:0];
plot(manu_soln(ibeg:iend),xx,'-o','markersize',8,'linewidth',2)
hold all
ibeg = 1+nx; iend = nx*2;  xx = [-X+dx/2:dx:0];
plot(manu_soln(ibeg:iend),xx,'-s','markersize',8,'linewidth',2)
ibeg = 1+nx*2; iend = nx*4;  xx = [dx/2:dx:X*2];
plot(manu_soln(ibeg:iend),xx,'-v','markersize',8,'linewidth',2)
hold all
set(gca,'fontweight','bold','fontsize',14)
grid on
legend('P^{Soil}','P^{Root}','P^{Xylem}')
ylabel('Z [m]')
title('(a) Manufactured solution')
xlabel('[Pa]')

subplot(2,3,4);
ibeg = 1; iend = nx; xx = [-X+dx/2:dx:0];
plot(source(ibeg:iend),xx,'-o','markersize',8,'linewidth',2)
ylim([-5 10])
set(gca,'fontweight','bold','fontsize',14)
grid on
ylabel('Z [m]')
xlabel('[kg s^{-1}]')
title('(b) Source term for soil')
title('(b) Source for P_{soil}')

subplot(2,3,5);
ibeg = 1+nx; iend = nx*2;  xx = [-X+dx/2:dx:0];
plot(source(ibeg:iend),xx,'-sr','markersize',8,'linewidth',2)
ylim([-5 10])
set(gca,'fontweight','bold','fontsize',14)
grid on
xlabel('[kg s^{-1}]')
title('(c) Source term for root')
title('(c) Source for P_{root}')

subplot(2,3,6)
ibeg = 1+nx*2; iend = nx*4;  xx = [dx/2:dx:X*2];
plot(source(ibeg:iend),xx,'-v','markersize',8,'linewidth',2,'color',[0.9290    0.6940    0.1250])
ylim([-5 10])
set(gca,'fontweight','bold','fontsize',14)
grid on
xlabel('[kg s^{-1}]')
title('(d) Source term for xylem')
title('(d) Source for P_{xylem}')
if (save_plot)
    orient landscape
    print('-dpdf', plot_filename,'-fillpage')
end


figure
subplot(2,3,1);
ibeg = 1; iend = nx; xx = [-X+dx/2:dx:0];
plot(liq_sat(ibeg:iend),xx,'-o','markersize',8,'linewidth',2)
ylim([-5 10])
set(gca,'fontweight','bold','fontsize',14)
grid on
ylabel('Z [m]')
xlabel('[-]')
title('(a) Liq. sat. for soil')

subplot(2,3,2);
ibeg = 1+nx; iend = nx*2;  xx = [-X+dx/2:dx:0];
plot(liq_sat(ibeg:iend),xx,'-sr','markersize',8,'linewidth',2)
ylim([-5 10])
set(gca,'fontweight','bold','fontsize',14)
grid on
xlabel('[-]')
title('(b) Liq. sat. for root')

subplot(2,3,3)
ibeg = 1+nx*2; iend = nx*4;  xx = [dx/2:dx:X*2];
plot(liq_sat(ibeg:iend),xx,'-v','markersize',8,'linewidth',2,'color',[0.9290    0.6940    0.1250])
ylim([-5 10])
set(gca,'fontweight','bold','fontsize',14)
grid on
xlabel('[-]')
title('(c) Liq. sat. for xylem')

subplot(2,3,4);
ibeg = 1; iend = nx; xx = [-X+dx/2:dx:0];
plot(rel_perm(ibeg:iend),xx,'-o','markersize',8,'linewidth',2)
ylim([-5 10])
set(gca,'fontweight','bold','fontsize',14)
grid on
ylabel('Z [m]')
xlabel('[-]')
title('(d) Rel. perm. for soil')

subplot(2,3,5);
ibeg = 1+nx; iend = nx*2;  xx = [-X+dx/2:dx:0];
plot(rel_perm(ibeg:iend),xx,'-sr','markersize',8,'linewidth',2)
ylim([-5 10])
set(gca,'fontweight','bold','fontsize',14)
grid on
xlabel('[-]')
title('(e) Rel. perm. for root')

subplot(2,3,6)
ibeg = 1+nx*2; iend = nx*4;  xx = [dx/2:dx:X*2];
plot(rel_perm(ibeg:iend),xx,'-v','markersize',8,'linewidth',2,'color',[0.9290    0.6940    0.1250])
ylim([-5 10])
set(gca,'fontweight','bold','fontsize',14)
grid on
xlabel('[-]')
title('(f) Rel. perm. for xylem')

