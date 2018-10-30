function mms_spac_plot_error_norm_and_ooa(X, nxs, comp_soln, manu_soln, problem_dim,...
    verbose, save_plots, plot_filename)
% MMS_SPAC_PLOT_ERROR_NORM_AND_OOA(X, nxs, comp_soln, manu_soln, problem_dim, verbose, save_plots, plot_filename)
% Makes plot of error norms (L1, L2, L_inf) and observed order of accuracy 
% for the MMS Soil-Plant continuum problem.
%
% Input arguments:
%   X             - Extend of domain in x-direction
%   nxs           - Number of grid points in x-direction
%   comp_soln     - Computed solution
%   manu_soln     - Manufactured solution
%   problem_dim   - Dimension of the problem
%   verbose       - Display slope of error norm w.r.t. grid size
%   save_plot     - 1 = Save plot as PDF 
%   plot_filename - Filename for the plot

figure;
clf
splot =0;
problem_types = {'only_soil','only_root','only_xylem','all'};
title_names   = {'(a) Error norm for P_{soil}','(b) Error norm for P_{root}','(c) Error norm for P_{xylem}','(d) Error norm for P_{all}'};
for ii = 1:length(problem_types)
    splot = splot + 1;
    problem_type = problem_types{splot};
    for iprob = 1:length(nxs)
        dx = X/nxs(iprob);
        switch problem_type
            case 'only_soil'
                ibeg = 1; iend = nxs(iprob);
            case 'no_soil'
                ibeg = 1+nxs(iprob); iend = nxs(iprob)*3;
            case 'only_root'
                ibeg = 1+nxs(iprob); iend = nxs(iprob)*2;
            case 'only_xylem'
                ibeg = 1+nxs(iprob)*2; iend = nxs(iprob)*4;
            case 'all'
                ibeg = 1; iend = nxs(iprob)*3;
            otherwise
                error(['Unknown problem_type ' problem_type])
        end
        
        e_norm_1(iprob)   = norm(comp_soln{iprob}(ibeg:iend) - manu_soln{iprob}(ibeg:iend),1)* (dx)^problem_dim    ;
        e_norm_2(iprob)   = norm(comp_soln{iprob}(ibeg:iend) - manu_soln{iprob}(ibeg:iend),2)* (dx^0.5)^problem_dim;
        e_norm_inf(iprob) = norm(comp_soln{iprob}(ibeg:iend) - manu_soln{iprob}(ibeg:iend),Inf);
    end
    %figure(1);
    subplot(3,2,splot)
    loglog(1./nxs(1:end),e_norm_1,'-v','linewidth',2);
    hold all;
    loglog(1./nxs(1:end),e_norm_2,'-o','linewidth',2);
    loglog(1./nxs(1:end),e_norm_inf,'-s','linewidth',2);
    loglog(1./nxs(1:5),1./((2.^[0:4]))   *0.1,'--c','linewidth',2)
    loglog(1./nxs(1:5),1./((2.^[0:4])).^2*0.1,'--k','linewidth',2)
    title(title_names{ii})
    
    if (verbose)
        nruns = length(nxs);
        
        tmp = [ones(nruns,1) log(1./nxs(1:end))'] \ log(abs(e_norm_1  ))';slope_1 = tmp(2);
        tmp = [ones(nruns,1) log(1./nxs(1:end))'] \ log(abs(e_norm_2  ))';slope_2 = tmp(2);
        tmp = [ones(nruns,1) log(1./nxs(1:end))'] \ log(abs(e_norm_inf))';slope_i = tmp(2);
        disp(' ')
        disp(title_names{ii})
        disp(['Slope norm_1   ' num2str(slope_1,'%02.2f')])
        disp(['Slope norm_2   ' num2str(slope_2,'%02.2f')])
        disp(['Slope norm_Inf ' num2str(slope_i,'%02.2f')])
    end
    
    if (splot == 1 || splot == 3)
        ylabel('[Pa]');
    end
    if (splot == 4)
        xlabel('dz [m]');
    end
    grid on
    
    ylim([10^-3 10^2])
    
    set(gca,'fontweight','bold','fontsize',14)
    
end

h = legend('$L_1$','$L_2$','$L_\infty$', '$\mathcal{O}(\Delta P)$','$\mathcal{O}((\Delta P)^2)$');
set(h,'Interpreter','latex');
set(h,'Position',[0.97 0.55 0.1 0.01]);
set(h,'Position',[0.7 0.2 0.1 0.01]);
legend boxoff
orient landscape

subplot(3,2,5)
semilogx(1./nxs(1:end-1),log(e_norm_1(1:end-1)./e_norm_1(2:end)) / log(2),'-v','linewidth',2);
hold all
semilogx(1./nxs(1:end-1),log(e_norm_2(1:end-1)./e_norm_2(2:end)) / log(2),'-v','linewidth',2);
semilogx(1./nxs(1:end-1),log(e_norm_inf(1:end-1)./e_norm_inf(2:end)) / log(2),'-v','linewidth',2);
ylim([0 3])
grid on
set(gca,'fontweight','bold','fontsize',14)
xlabel('dz [m]');
ylabel('[-]')
title('(e) Order of accuracy for P_{all}')
set(h,'Interpreter','latex');
if (save_plots)
    orient landscape
    print('-dpdf', plot_filename,'-fillpage')
end