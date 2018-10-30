function mms_thermal_driver(varargin)
% MMS_THERMAL_DRIVER  Perform Method of Manufactured Solution analysis of the
% thermal diffusion model for a 1D problem.
%
%    MMS_THERMAL_DRIVER('mpp_exec_dir','path-to-mpp') 
%    Runs the 'thermal_mms' executable that is installed in the mpp_exec_dir. 
%    Additionally, following plots are made:
%      1. Error norms and observed order of accuracy,
%      2. Error between the computed and true solution
%      3. Manufactured solutions, thermal conductivity, and the source term
%
%    MMS_THERMAL_DRIVER('read_data','data.mat')
%    Instead of running the MPP library, this case used pre-generated MMS data
%    saved in a mat file.
%
%    MMS_THERMAL_DRIVER(..., 'save_data',1) Save MMS data as a *.mat file
%
%    MMS_THERMAL_DRIVER(..., 'save_plots',1) Save the plots as PDFs
%
%    MMS_THERMAL_DRIVER(..., 'verbose',1) Turns verbosity on
%

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Problem specific settings
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

X            = 1;
nxs          = 5 * 2.^[0:3];
problem_dim  = 3;
exec_name    = 'thermal_mms';

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
    data_variables = {'comp_soln','manu_soln','thermal_cond','source'};
    check_data_file(data_file, data_variables);
    save_data = 0;
else
    check_MPP(mpp_exec_dir, exec_name);
    check_PETSc_MATLAB();
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Run the simulation at multiple spatial resultions
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if (read_data)
    if (verbose); disp(['Reading data from ' data_file]);end
    load(data_file);
else
    if (verbose); disp('Running simulations');end
    [comp_soln, manu_soln, thermal_cond, source] = ...
        mms_thermal_run_simulation(nxs, problem_dim, ...
        mpp_exec_dir, exec_name, verbose);
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% If needed, save the data
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if (save_data)
    save([exec_name '.mat'], ...
        'comp_soln','manu_soln','source','thermal_cond');
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Compute error norms
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
[e_norm_1, e_norm_2, e_norm_inf] = mms_thermal_compute_error(...
    X, nxs, problem_dim, comp_soln, manu_soln);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Make plot of error norm vs mesh size AND Observed order of accuracy
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dxs=X./nxs;
mms_thermal_plot_error_norm_and_ooa(dxs, e_norm_1, e_norm_2, e_norm_inf, ...
    verbose, save_plots, [exec_name '_norm_and_ooa.pdf']);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Make plot of error between computed and manufactured solution
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Pick the run id for generating run-specific plots
ii = 4;

% Get mesh-related information for the choosen run
nn = nxs(ii);
dx = X/nn;
dy = dx;
dz = dx;

x = dx/2:dx:X;
y = dy/2:dy:X;
z = dz/2:dz:X;

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Plot manufactured solutions
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mms_thermal_plot_mms(x,y,z,manu_soln{ii},thermal_cond{ii},source{ii},save_plots,exec_name);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Error between computed and manufactured solution
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mms_thermal_plot_error(x,y,z, comp_soln{ii}, manu_soln{ii}, ...
    save_plots, [exec_name '_error.pdf']);
