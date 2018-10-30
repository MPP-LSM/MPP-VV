function mms_th_plot_error_norm_and_ooa(X, nxs, comp_soln, manu_soln, problem_dim, ...
    verbose, save_plot, plot_filename)
% MMS_TH_PLOT_ERROR_NORM_AND_OOA(X, nxs, comp_soln, manu_soln, problem_dim, verbose, save_plot, plot_filename)
% Makes plot of error norms (L1, L2, L_inf) and observed order of accuracy 
% for the MMS TH problem.
%
% Input arguments
%   X             - Extend of domain in x-direction
%   nxs           - Number of grid cells in x-direction for each resolution
%   comp_soln     - Computed solution
%   manu_soln     - Manufactured solution
%   problem_dim   - Dimension of problem
%   verbose       - Display slope of error norm w.r.t. grid size
%   save_plot     - 1 = Save plot as PDF 
%   plot_filename - Filename for the plot

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Error norm vs mesh size AND Observed order of accuracy
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
first_order_of_conv = 1;
title_names = {'(a) Error norm for P','(b) Error norm for T'};

figure;

for ii = 1:2
    clear e_norm_1 e_norm_2 e_norm_inf
    for iprob = 1:length(nxs)
        nx = nxs(iprob);
        dx = X/nx;
        ibeg = nx*(ii-1) + 1;
        iend = nx*ii;
        e_norm_1(iprob)   = norm(comp_soln{iprob}(ibeg:iend) - manu_soln{iprob}(ibeg:iend),1)* (dx)^problem_dim    ;
        e_norm_2(iprob)   = norm(comp_soln{iprob}(ibeg:iend) - manu_soln{iprob}(ibeg:iend),2)* (dx^0.5)^problem_dim;
        e_norm_inf(iprob) = norm(comp_soln{iprob}(ibeg:iend) - manu_soln{iprob}(ibeg:iend),Inf);
    end
    
    
    subplot(2,2,ii)
    loglog(X./nxs(1:end),e_norm_1,'-v','linewidth',2);
    hold all;
    loglog(X./nxs(1:end),e_norm_2,'-o','linewidth',2);
    loglog(X./nxs(1:end),e_norm_inf,'-s','linewidth',2);
    loglog(X./nxs(1:3),2.^(-[0:2]*first_order_of_conv)*e_norm_2(1)/3,'--k','linewidth',2)
    switch ii
        case 1
            ylabel('Error [Pa]')
        case 2
            ylabel('Error [K]')
    end
    
    grid on
    title(title_names{ii})
    set(gca,'fontweight','bold','fontsize',14)
    
    nruns = length(nxs);
    
    tmp = [ones(nruns,1) log(X./nxs(1:end))'] \ log(abs(e_norm_1  ))';slope_1 = tmp(2);
    tmp = [ones(nruns,1) log(X./nxs(1:end))'] \ log(abs(e_norm_2  ))';slope_2 = tmp(2);
    tmp = [ones(nruns,1) log(X./nxs(1:end))'] \ log(abs(e_norm_inf))';slope_i = tmp(2);
    if (verbose)
        disp(' ')
        disp(title_names{ii})
        disp(['Slope norm_1   ' num2str(slope_1,'%02.2f')])
        disp(['Slope norm_2   ' num2str(slope_2,'%02.2f')])
        disp(['Slope norm_Inf ' num2str(slope_i,'%02.2f')])
    end
    
    switch ii
        case 1
            h=legend('$L_1$','$L_2$','$L_\infty$', '$\mathcal{O}(\Delta P)$','location','northwest');
        case 2
            h=legend('$L_1$','$L_2$','$L_\infty$', '$\mathcal{O}(\Delta T)$','location','northwest');
    end
    set(h,'Interpreter','latex');
    
end

title_names = {'(c) Order of accruacy for P','(d) Order of accruacy for T'};

for ii = 1:2
    clear e_norm_1 e_norm_2 e_norm_3
    for iprob = 1:length(nxs)
        nx = nxs(iprob);
        dx = X/nx;
        ibeg = nx*(ii-1) + 1;
        iend = nx*ii;
        e_norm_1(iprob)   = norm(comp_soln{iprob}(ibeg:iend) - manu_soln{iprob}(ibeg:iend),1)* (dx)^problem_dim    ;
        e_norm_2(iprob)   = norm(comp_soln{iprob}(ibeg:iend) - manu_soln{iprob}(ibeg:iend),2)* (dx^0.5)^problem_dim;
        e_norm_inf(iprob) = norm(comp_soln{iprob}(ibeg:iend) - manu_soln{iprob}(ibeg:iend),Inf);
    end
    subplot(2,2,ii+2)
    semilogx(X./nxs(1:end-1),log(e_norm_1(1:end-1)./e_norm_1(2:end)) / log(2),'-v','linewidth',2);
    ylim([0 2])
    xlabel('dx [m]')
    
    grid on
    set(gca,'fontweight','bold','fontsize',14)
    switch ii
        case 1
            ylabel('-')
        case 2
    end
    
    grid on
    title(title_names{ii})
    h=legend('Based on $L_1$','location','northwest');
    set(h,'Interpreter','latex');
end

if (save_plot)
    orient landscape
    print('-dpdf', plot_filename,'-fillpage')
end