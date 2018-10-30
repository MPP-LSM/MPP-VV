function mms_spac_driver(varargin)
% MMS_SPAC_DRIVER  Perform Method of Manufactured Solution analysis of the
% the Soil-Plant continuum 1D problem
%
%    MMS_SPAC_DRIVER('mpp_exec_dir','path-to-mpp','problem_type',0) 
%    Runs the 'vsfm_mms' executable that is installed in the mpp_exec_dir.
%    Additionally, following three plots are made:
%      1. Error norms and observed order of accuracy,
%      2. Error between the computed and true solution
%      3. Manufactured solutions
%
%    MMS_SPAC_DRIVER('read_data','data.mat','problem_type',0)
%    Instead of running the MPP library, this case used pre-generated MMS data
%    saved in a mat file.
%
%    MMS_SPAC_DRIVER(..., 'save_data',1) Save MMS data as a *.mat file
%
%    MMS_SPAC_DRIVER(..., 'save_plots',1) Save the plots as PDFs
%
%    MMS_SPAC_DRIVER(..., 'verbose',1) Turns verbosity on
%

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Problem specific settings
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
problem_dim  = 1;
X            = 5;
grid_factors = 2.^[1:6];
nxs          = grid_factors*10;
exec_name    = 'vsfm_spac_mms';

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Input arguments
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
verbose      = 0;
save_plots   = 0;
save_data    = 0;
read_data    = 0;
data_file    = '';
mpp_exec_dir = '';

for ii = 1:2:length(varargin)
    switch lower(varargin{ii})
        case 'verbose'
            verbose = varargin{ii+1};
        case 'save_plots'
            save_plots = varargin{ii+1};
        case 'save_data'
            save_data = varargin{ii+1};
        case 'read_data'
            read_data = 1; 
            data_file = varargin{ii+1};
        case 'mpp_exec_dir'
            mpp_exec_dir = varargin{ii+1};
        otherwise
            error(['Unknown argument: ' varargin{ii}]);
    end
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Perform few checks
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if (isempty(mpp_exec_dir) && ~read_data)
    error(['Need to specify one of the following arguments: ' char(10) ...
        '1.  (' char(39) 'mpp_exec_dir' char(39) ', ' char(39) 'path-to-mpp-exec-dir' char(39) ')' char(10) ...
        '2.  (' char(39) 'read_data' char(39) ', ' char(39) 'path-to-mat-data-file' char(39) ')' char(10) ...
        ]);
elseif (~isempty(mpp_exec_dir) && read_data)
    error(['Only one of the following arguments can be specified: ' char(10) ...
        '1.  (' char(39) 'mpp_exec_dir' char(39) ', ' char(39) 'path-to-mpp-exec-dir' char(39) ')' char(10) ...
        '2.  (' char(39) 'read_data' char(39) ', ' char(39) 'path-to-mat-data-file' char(39) ')' char(10) ...
        ]);
end

if (read_data);
    data_variables = {'comp_soln','manu_soln','source','liq_sat','rel_perm'};
    check_data_file(data_file, data_variables);
    save_data = 0;
else
    check_MPP(mpp_exec_dir, exec_name);
    check_PETSc_MATLAB();
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Read the data from mat file or run MPP library
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if (read_data)
    if (verbose); disp(['Reading data from ' data_file]);end
    load(data_file);
else
    if (verbose); disp('Running simulations');end
    [comp_soln, manu_soln, source, liq_sat, rel_perm] = ...
        mms_spac_run_simulation(grid_factors, mpp_exec_dir, exec_name, verbose);
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% If needed, save the data
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if (save_data)
    save([exec_name '.mat'], ...
        'comp_soln','manu_soln','source','liq_sat','rel_perm');
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Error norm vs mesh size AND Observed order of accuracy
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mms_spac_plot_error_norm_and_ooa(X, nxs, comp_soln, manu_soln, problem_dim,...
    verbose, save_plots, [exec_name '_norm_and_ooa.pdf']);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Make plot of error between computed and manufactured solution
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Pick the run id for generating run-specific plots
iprob = 1;

% Get mesh-related information for the choosen run
dx = X/(2^iprob*10);

mms_spac_plot_error(X, dx, nxs(iprob), comp_soln{iprob}, manu_soln{iprob}, ...
    save_plots, [exec_name '_error.pdf'])

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Manufactured solution: Pressure and Source
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mms_spac_plot_mms(X, dx, nxs(iprob), manu_soln{iprob}, source{iprob}, ...
    liq_sat{iprob}, rel_perm{iprob}, save_plots, [exec_name '_solution_and_source.pdf'])
