function mms_vsfm_driver(varargin)
% MMS_VSFM_DRIVER  Perform Method of Manufactured Solution analysis of the
% Variably Saturated Flow Model for a 1D problem
%
%    MMS_VSFM_DRIVER('mpp_exec_dir','path-to-mpp','problem_type',0) 
%    Runs the 'vsfm_mms' executable that is installed in the mpp_exec_dir 
%    for the unsaturated flow proble (problem_type = 0). Additionally,
%    following three plots are made:
%      1. Error norms and observed order of accuracy,
%      2. Error between the computed and true solution
%      3. Manufactured solutions, liquid saturation, and the source term
%
%    Valid values for problem_type 
%      0 - An unsaturated flow problem
%      1 - A fully saturated flow problem
%
%    MMS_VSFM_DRIVER('read_data','data.mat','problem_type',0)
%    Instead of running the MPP library, this case used pre-generated MMS data
%    saved in a mat file.
%
%    MMS_VSFM_DRIVER(..., 'save_data',1) Save MMS data as a *.mat file
%
%    MMS_VSFM_DRIVER(..., 'save_plots',1) Save the plots as PDFs
%
%    MMS_VSFM_DRIVER(..., 'verbose',1) Turns verbosity on
%

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Problem specific settings
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
problem_dim = 1;
X           = 10;                 % Extent of the problem [m]
nxs         = [20 40 80 160 320]; % Number grid cells in x-direction
exec_name   = 'vsfm_mms';

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Input arguments
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
problem_type = -1;
verbose      = 0;
save_plots   = 0;
save_data    = 0;
read_data    = 0;
data_file    = '';
mpp_exec_dir = '';

for ii = 1:2:length(varargin)
    switch lower(varargin{ii})
        case 'problem_type'
            problem_type = varargin{ii+1};
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

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Perform few checks
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if (problem_type == -1)
    error(['Argument ' char(39) 'problem_type' char(39) ' was not specified.']);
elseif (problem_type < 0 || problem_type > 1)
    error(['Valid values for ' char(39) 'problem_type' char(39) ' are: ' char(10) ...
        ' 0 = Unsaturated flow prolbem ' char(10)...
        ' 1 = Saturated flow problem']);
end

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
    data_variables = {'comp_soln','manu_soln','perm','source','sat'};
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
    [comp_soln, manu_soln, perm, source, sat] = ...
        mms_vsfm_run_simulation(nxs, problem_type, mpp_exec_dir, exec_name, verbose);
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% If needed, save the data
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if (save_data)
    save([exec_name '.problem_type_' num2str(problem_type) '.mat'], ...
        'comp_soln','manu_soln','perm','source','sat');
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Compute error norms
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
[e_norm_1, e_norm_2, e_norm_inf] = ...
    mms_vsfm_compute_error(X, nxs, problem_dim, comp_soln, manu_soln);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Make plot of error norm vs mesh size AND Observed order of accuracy
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dxs=X./nxs;
mms_vsfm_plot_error_norm_and_ooa(dxs, e_norm_1, e_norm_2, e_norm_inf, ...
    problem_type, verbose, save_plots, [exec_name '_problem' num2str(problem_type) '_norm_and_ooa.pdf']);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Make plot of error between computed and manufactured solution
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Pick the run id for generating run-specific plots
ii=4; dx=X/nxs(ii); xx=[dx/2:dx:X];

mms_vsfm_plot_error(xx, comp_soln{ii}, manu_soln{ii}, ...
    save_plots, [exec_name '_problem' num2str(problem_type) '_error.pdf']);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Plot manufactured solutions
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ii = 4;dx=X/nxs(ii);xx=[dx/2:dx:X];

mms_vsfm_plot_mms(xx,manu_soln{ii},perm{ii},sat{ii},source{ii}, save_plots, ...
    [exec_name '_problem' num2str(problem_type) '_solution_and_source.pdf']);

