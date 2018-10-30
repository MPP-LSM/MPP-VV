function [comp_soln, manu_soln, perm, source] = ...
    mms_th_run_simulation(nxs, mpp_exec_dir, exec_name, verbose)
% [comp_soln, manu_soln, perm, source] = MMS_TH_RUN_SIMULATION(nxs, mpp_exec_dir, exec_name, verbose)
% Runs the MMS TH problem for multiple spatial resolutions and returns
% true and manufactured solutions.
%
% Input arguments:
%   nxs          - Number of grid spacing in x-direction
%   mpp_exec_dir - Path to MPP library directory
%   exec_name    - Name of the MPP exectuable that will be run
%   verbose      - Turns on/off verbosity
%
% Output values
%   comp_soln - Computed solution
%   manu_soln - Manufactured solution
%   perm      - Manufactured permeabilty
%   source    - Source term associated with manufactured solution
%

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Run the simulation at multiple spatial resultions
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
count = 0;
for nx = nxs
    soln_file_name = sprintf('soln_%d.bin',nx);
    cmd_txt= ['(cd /Users/gbisht/projects/smpp/mpp-master/local/bin; ./th_mms -snes_monitor -snes_view_solution' ...
        ' binary:computed_' soln_file_name ' -ksp_monitor -pc_type lu ' ...
        sprintf('-nx %d',nx) ' -view_true_solution true_' soln_file_name ' -view_source ' sprintf('source_%d.bin',nx) ...
        ' -view_permeability ' sprintf('perm_%d.bin',nx) '  > output.txt)'];
    ocount = 0;
    ocount=ocount+1;option{ocount}='-pc_type'             ;option_value{ocount}=sprintf('lu');
    ocount=ocount+1;option{ocount}='-nx'                  ;option_value{ocount}=sprintf('%d',nx);
    ocount=ocount+1;option{ocount}='-snes_view_solution ' ;option_value{ocount}=sprintf('binary:%s.computed_soln_%d.bin',exec_name,nx);fname_comp_soln = option_value{ocount}(8:end);
    ocount=ocount+1;option{ocount}='-view_true_solution'  ;option_value{ocount}=sprintf('%s.true_soln_%d.bin',exec_name,nx)           ;fname_true_soln = option_value{ocount};
    ocount=ocount+1;option{ocount}='-view_permeability'   ;option_value{ocount}=sprintf('%s.perm_%d.bin',exec_name,nx)                ;fname_perm      = option_value{ocount};
    ocount=ocount+1;option{ocount}='-view_source'         ;option_value{ocount}=sprintf('%s.source_%d.bin',exec_name,nx)              ;fname_source    = option_value{ocount};
    
    % Create the command to run the executable
    option       = add_whitespace_padding(option);
    option_value = add_whitespace_padding(option_value);
    cmd_txt= ['(cd ' mpp_exec_dir '; \'  char(10)...
        './' exec_name ' \' char(10)];
    for ii = 1:length(option)
        cmd_txt = [cmd_txt option{ii} ' ' option_value{ii} ' \' char(10)];
    end
    cmd_txt = [cmd_txt ')' char(10)];
    
    if (verbose); disp(cmd_txt); end;
    
    system(cmd_txt);
    
    count = count + 1;
    comp_soln{count}  = PetscBinaryRead(sprintf('%s/%s',mpp_exec_dir,fname_comp_soln));
    manu_soln{count}  = PetscBinaryRead(sprintf('%s/%s',mpp_exec_dir,fname_true_soln));
    perm{count}       = PetscBinaryRead(sprintf('%s/%s',mpp_exec_dir,fname_perm));
    source{count}     = PetscBinaryRead(sprintf('%s/%s',mpp_exec_dir,fname_source));
    
end
