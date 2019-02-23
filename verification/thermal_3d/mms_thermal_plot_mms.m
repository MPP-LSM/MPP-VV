function mms_thermal_plot_mms(x,y,z,manu_soln,thermal_cond,source,save_plot,exec_name)
% MMS_THERMAL_PLOT_MMS(x,y,z,manu_soln,perm,sat,source,save_plot,plot_filename)
% Makes plot of manufactured solutions for the MMS thermal problem
%
%  x             - Grid in x-direction
%  y             - Grid in y-direction
%  z             - Grid in z-direction
%  manu_soln     - Manufacture solution of pressure
%  thermal_cond  - Manufactured solution of soil thermal conductivity
%  source        - Source term corresponding to manufactured solutions
%  save_plot     - 1 = Save plot as PDF 
%  plot_filename - Filename for the plot

nn = length(x);

figure;
slice(x,y,z,reshape(manu_soln,nn,nn,nn),[.25 .75], .50, [.25 .75]);
colormap jet
set(gca,'fontweight','bold','fontsize',24)
h = colorbar;
title(h,'[K]')
xlabel('[m]')
ylabel('[m]')
zlabel('[m]')
orient landscape
gca_pos = get(gca,'Position');
hp = get(h,'Position');hp(1)=0.88;set(h,'Position',hp);
set(gca,'Position',gca_pos)
title(sprintf('(a) Manufactured solution of temperature'))
if (save_plot)
    print('-dpdf', [exec_name '_solution.pdf'],'-fillpage')
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Manufactured solution: Source term
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
figure;
slice(x,y,z,reshape(source,nn,nn,nn),[.25 .75], .50, [.25 .75]);
colormap jet
set(gca,'fontweight','bold','fontsize',24)
h = colorbar;
title(h,'[J s^{-1}]')
xlabel('[m]')
ylabel('[m]')
zlabel('[m]')
caxis([-0.04 0.04])
orient landscape
gca_pos = get(gca,'Position');
hp = get(h,'Position');hp(1)=0.88;set(h,'Position',hp);
set(gca,'Position',gca_pos)
title(sprintf('(c) Analytical estimate of the source term'))
if (save_plot)
    print('-dpdf', [exec_name '_source.pdf'],'-fillpage')
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Manufactured solution: Thermal conductivity
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
figure;
slice(x,y,z,reshape(thermal_cond,nn,nn,nn),[.25 .75], .50, [.25 .75]);
colormap jet
set(gca,'fontweight','bold','fontsize',24)
h = colorbar;
title(h,'   [W m^{-1} K^{-1}]')
xlabel('[m]')
ylabel('[m]')
zlabel('[m]')
caxis([.1 3])
orient landscape
gca_pos = get(gca,'Position');
hp = get(h,'Position');hp(1)=0.88;set(h,'Position',hp);
set(gca,'Position',gca_pos)
th=title(sprintf('(b) Spatially varying thermal conductivity'));
if (save_plot)
    print('-dpdf', [exec_name '_thermal_conductivity.pdf'],'-fillpage')
end

