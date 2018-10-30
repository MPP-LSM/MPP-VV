function [e_norm_1, e_norm_2, e_norm_inf] = mms_thermal_compute_error(...
    X, nxs, problem_dim, comp_soln, manu_soln)
% [e_norm_1, e_norm_2, e_norm_inf] = MMS_THERMAL_COMPUTE_ERROR(X, nxs, problem_dim, comp_soln, manu_soln)
% Computes L1, L2, and L-infinity error norms for the MMS thermal problem.
%
%   X           - Grid extent in X-dir
%   nxs         - Number of grid cells in x-dir
%   problem_dim - Dimension of the problem
%   comp_soln   - Computed solution
%   manu_soln   - Manufactured solution

for ii = 1:length(comp_soln)
    dx = X/nxs(ii);
    
    e_norm_1(ii)   = norm(comp_soln{ii} - manu_soln{ii},1)* (dx)^problem_dim    ;
    e_norm_2(ii)   = norm(comp_soln{ii} - manu_soln{ii},2)* (dx^0.5)^problem_dim;
    e_norm_inf(ii) = norm(comp_soln{ii} - manu_soln{ii},Inf);
end

