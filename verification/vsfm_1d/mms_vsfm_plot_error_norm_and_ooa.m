function mms_vsfm_plot_error_norm_and_ooa(dxs, e_norm_1, e_norm_2, e_norm_inf, ...
    problem_type, verbose, save_plot, plot_filename)
% MMS_VSFM_PLOT_ERROR_NORM_AND_OOA Makes plot of error norms (L1, L2,
% L_inf) and observed order of accuracy for the MMS VSFM problem.
%
%  dxs           - Grid spacing in x-direction for each resolution
%  e_norm_1      - L1 error norm
%  e_norm_2      - L2 error norm
%  e_norm_inf    - L-infinity error norm
%  problem_type  - Unsaturated problem (=0) or saturated problem (=1)
%  verbose       - Display slope of error norm w.r.t. grid size
%  save_plot     - 1 = Save plot as PDF 
%  plot_filename - Filename for the plot

first_order_of_conv  = 1;
second_order_of_conv = 2;
figure;
clf
subplot(1,2,1)
loglog(dxs(1:end),e_norm_1,'-v','linewidth',2);
hold all;
loglog(dxs(1:end),e_norm_2,'-o','linewidth',2);
loglog(dxs(1:end),e_norm_inf,'-s','linewidth',2);
if (~problem_type)
    loglog(dxs(1:3),2.^(-[0:2]*first_order_of_conv)*e_norm_2(1)/3,'--k','linewidth',2)
else
    loglog(dxs(1:3),2.^(-[0:2]*second_order_of_conv)*e_norm_2(1)/3,'--k','linewidth',2)
end
xlabel('dx [m]')
ylabel('[Pa]')
grid on
if (~problem_type)
    h=legend('$L_1$','$L_2$','$L_\infty$', '$\mathcal{O}(\Delta P)$','location','northwest');
else
    h=legend('$L_1$','$L_2$','$L_\infty$', '$\mathcal{O}(\Delta P^2)$','location','northwest');
end
set(h,'Interpreter','latex');
set(gca,'fontweight','bold','fontsize',14)
title('(a) Error norm')

subplot(1,2,2)
semilogx(dxs(1:end-1),log(e_norm_1(1:end-1)./e_norm_1(2:end)) / log(2),'-v','linewidth',2);
hold all
semilogx(dxs(1:end-1),log(e_norm_2(1:end-1)./e_norm_2(2:end)) / log(2),'-o','linewidth',2);
semilogx(dxs(1:end-1),log(e_norm_inf(1:end-1)./e_norm_inf(2:end)) / log(2),'-s','linewidth',2);
ylim([0 3])
xlabel('dx [m]')
ylabel('[-]')
grid on
set(gca,'fontweight','bold','fontsize',14)
h=legend('Using $L_1$','Using $L_2$','Using $L_\infty$','location','northwest');
set(h,'Interpreter','latex');
title('(b) Order of accuracy')
if (save_plot)
    orient landscape
    print('-dpdf', plot_filename,'-fillpage')
end

if (verbose)
    nruns = length(dxs);
    
    tmp = [ones(nruns,1) log(dxs(1:end))'] \ log(abs(e_norm_1  ))';slope_1 = tmp(2);
    tmp = [ones(nruns,1) log(dxs(1:end))'] \ log(abs(e_norm_2  ))';slope_2 = tmp(2);
    tmp = [ones(nruns,1) log(dxs(1:end))'] \ log(abs(e_norm_inf))';slope_i = tmp(2);
    disp(['Slope norm_1   ' num2str(slope_1)])
    disp(['Slope norm_2   ' num2str(slope_2)])
    disp(['Slope norm_Inf ' num2str(slope_i)])
end
